% track face image, select ROI, PCA process
% version 1.1
% date 2107.02.01
% fix the cut point depending on the first frame

function roiImgAll = getROIper1stFr(img_path,fstFr,lastFr,sizeROI,posRoi,temp1,nbROI,nbLm,indexChar,outputROIper1stFr)
nbFig =lastFr-fstFr+1;
roiImgAll = zeros(sizeROI,sizeROI,nbFig,nbLm); 

%% cut images depending on the first point
for ii = 1:lastFr-fstFr+1  
    faceName = [img_path, temp1(fstFr+ii-1).name];
 
    
    imRaw = imread(faceName);
    if size(size(imRaw),2) ==3
        imGray = rgb2gray(imRaw);
    elseif size(size(imRaw),2) ==2
        imGray = imRaw;
    end
    % cut image depending on different landmarks
    for jj = 1:nbLm
        posROI = posRoi(nbROI(jj),:);   % all depending on the first frame 
        posROI = uint32(posROI);
        move_horizontal =0;
        move_vertical =0;
        move_roi_H = 0;
        move_roi_V = 0;
        if posROI(1,1)+(sizeROI/2)>size(imGray,2)
            move_horizontal =  (posROI(1,1)+(sizeROI/2))- size(imGray,2) ;
        elseif posROI(1,1)+(sizeROI/2) < sizeROI
            move_roi_H = sizeROI - (posROI(1,1)+(sizeROI/2));
        end
        if posROI(1,2)+ (sizeROI/2)> size(imGray,1)
            move_vertical= (posROI(1,2)+ (sizeROI/2))-size(imGray,1) ; 
        elseif  posROI(1,2)+ (sizeROI/2) < sizeROI
            move_roi_V = sizeROI - (posROI(1,2)+ (sizeROI/2));
        end
         
        imcut = imGray((posROI(1,2)-(sizeROI/2)+1:posROI(1,2)+ (sizeROI/2)+ move_roi_V)-move_vertical,(posROI(1,1)-(sizeROI/2)+1:posROI(1,1)+(sizeROI/2)+move_roi_H)-move_horizontal);  
        roiImgAll(:,:,ii,jj) = imcut;
    end
end
%%  save the data
for kk = 1:nbLm
    roiImg = roiImgAll(:,:,:,kk);
    save([outputROIper1stFr,indexChar,'_size_',num2str(sizeROI*sizeROI),'_ROI_',num2str(nbROI(kk)),'_ROI.mat'], 'roiImg');
end
disp([indexChar,' video generation finish'])

end


