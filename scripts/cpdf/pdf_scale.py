import sys
import os
import subprocess

def read_from_clipboard():
    return subprocess.check_output(
        'pbpaste', env={'LANG': 'en_US.UTF-8'}).decode('utf-8')

target_size = int(sys.argv[1])

#f = read_from_clipboard()
f = sys.argv[2]
command = "/Users/inikolaenko/scripts/cpdf/cpdf -scale-to-fit \"{0}pt {0}pt\" {1} -o {1}".format(target_size, f)
print("cmd: " + command)
os.system(command)
