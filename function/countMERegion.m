function move_region = countMERegion(debut,fin,rightSide,leftSide,dectPerVideo,currentRegion)
move_region = 0; 
for aa = debut:fin
     if aa ==currentRegion
         continue
     else
         for bb = rightSide:leftSide
             if dectPerVideo(aa,bb)==1 
                 move_region =move_region+1;
                 break;
             end
         end
     end
 end