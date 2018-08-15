#!/usr/bin/env xcrun swift


import Foundation

/// Constants:
let RAMDISK_GB = 4 // Set the number of gigabytes for the RAM disk here!
let home = NSHomeDirectory()
let derivedDataPath = "\(home)/Library/Developer/Xcode/DerivedData"

/**
 - returns: Bool true if the ram disk already exists.
 */
func ramDiskExists() -> Bool
{
    let output = runTask(launchPath: "/sbin/mount", arguments: [])
    let regex: NSRegularExpression?

    do {
        regex = try NSRegularExpression(pattern: "/dev/disk.*Library/Developer/Xcode/DerivedData.*mounted",
                                        options: NSRegularExpression.Options.caseInsensitive)

        let numberOfMatches = regex!.numberOfMatches(in: output,
                                                     options: [],
                                                     range: NSMakeRange(0, output.characters.count))

        if numberOfMatches == 1 {
            print("RAM disk is already mounted.\n")
            print(output)

            return true
        }
    } catch let error as NSError {
        print("error: \(error.localizedDescription)")
        assert (false)
    }

    return false
}

/**
 - parameter Int for number of blocks to use for the ram disk.
 - returns: Bool true if the creation of the ram disk is successful.
 */
func createRamDisk(blocks: Int) -> Bool
{
    let output = runTask(launchPath: "/usr/bin/hdid", arguments: ["-nomount", "ram://\(blocks)"])
    let allOutput = NSMakeRange(0, output.characters.count)
    let regex: NSRegularExpression?

    do {
        regex = try NSRegularExpression(pattern: "/dev/disk(\\d+)", options: NSRegularExpression.Options.caseInsensitive)
        let numberOfMatches = regex!.numberOfMatches(in: output, options: [], range: allOutput)

        print("output \(output)")

        if numberOfMatches == 1 {
            let matches = regex?.matches(in: output, options: [], range: allOutput)

            for match in matches! {
                let matchRange: NSRange = match.rangeAt(1)
                let disk = output.substring(with: output.index(output.startIndex, offsetBy: matchRange.location) ..<
                    output.index(output.startIndex, offsetBy: (matchRange.location + matchRange.length)))
                makeFilesystemOn(disk: disk)
                addRamDiskToSpotlight()
            }
        } else {
            return false
        }
    } catch let error as NSError {
        print("error: \(error.localizedDescription)")
        assert (false)
    }

    return true
}

func makeFilesystemOn(disk: String)
{
    let drive = "/dev/rdisk\(disk)"
    let output = runTask(launchPath: "/sbin/newfs_hfs",
                         arguments: ["-v", "DerivedData", drive])

    print(output)

    mountRamDisk(drive: drive)
}

func mountRamDisk(drive: String)
{
    let output = runTask(launchPath: "/usr/sbin/diskutil",
                         arguments: ["mount", "-mountPoint", derivedDataPath, drive])

    print(output)
}

/// Add to Spotlight so that Instruments can find symbols.
func addRamDiskToSpotlight()
{
    let output = runTask(launchPath: "/usr/bin/mdutil",
                         arguments: [derivedDataPath, "-i", "on"])

    print(output)
}

func runTask(launchPath: String, arguments: [String]) -> String
{
    let task = Process()
    task.launchPath = launchPath
    task.arguments = arguments

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()

    return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
}

print("Setting up RAM disk for Xcode.\n")

if !ramDiskExists() {
    let result = createRamDisk(blocks: RAMDISK_GB * 1024 * 2048)
    if result {
        print("Created RAM disk.")
    } else {
        print("Unable to create RAM disk.")
    }
} else {
    print("RAM disk for Derived Data already exists.")
}
