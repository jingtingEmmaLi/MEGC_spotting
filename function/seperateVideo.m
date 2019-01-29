%% function to seperate ME clips in one video

function [newMEbegin, newMEend,indexME, newOnset, newOffset]  = seperateVideo(nbMulti, currentVideo, nbfile,k)
videomulti = size(nbMulti,1);
for ii = 1: videomulti
    firstVideoIndex = nbMulti(ii,2)-nbMulti(ii,1)+1;
    if currentVideo <= nbMulti(ii,2) && currentVideo >= firstVideoIndex
        
        if currentVideo == firstVideoIndex
            indexME = 1;
            newMEbegin = 1; 
            newMEend = nbfile(currentVideo,3)+k;  
            newOnset = nbfile(currentVideo,2);
            newOffset = nbfile(currentVideo,3);
        elseif currentVideo == nbMulti(ii,2)
            indexME = nbMulti(ii,1);
            newMEend = nbfile(currentVideo,1);% nbframe
            newMEbegin = nbfile(currentVideo,2)-k;
            newOnset = k+1;
        newOffset = nbfile(currentVideo,3) - nbfile(currentVideo,2)+k+1;
        else
            indexME = nbMulti(ii,1)-nbMulti(ii,2)+currentVideo;
            newMEbegin = nbfile(currentVideo,2)-k;          % onset(i)-k        
        newMEend = nbfile(currentVideo,3)+k;       % onset(i+1)-k-1
        newOnset = k+1;
        newOffset = nbfile(currentVideo,3) - nbfile(currentVideo,2)+k+1;
            
        end            
    end
end
end
