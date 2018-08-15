j=0;
for i in *.jpg
do let j+=1;
mv $i planet_animation_frame_$j@3x.jpg ;
done
