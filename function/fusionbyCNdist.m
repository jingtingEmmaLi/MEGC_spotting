%% fusion
function [originalMLresult,detectionME,temporalGlobalBDD,spatialGlobalBDD,MergeBDD,videoFrame] = ...
    fusionbyCNdist(vector2test,predicted_label,test_feature_info,nbROI,window,seuil_indensity,spa_switch,r_w_ROI,cn_ratio,r_w_frame)
% info first colomn : video index
% info second colomn: frame number per video
% info third colomn : lable number per video
% info fourth colomn : accumulated lable number

nbvideo = size(test_feature_info,1);
nbRegion = size(nbROI,2);
coeff_norm = vector2test(:,1);
if nbRegion ==12
    pos_nose =7;
    nb_nose = 2;
    pos_mouth = 9;
    
    nb_mouth = 4;
elseif nbRegion ==26
    pos_nose =11;
    nb_nose = 4;
    pos_mouth = 15;
    
    nb_mouth = 12;
end
    
detectionME = zeros(uint64(test_feature_info(nbvideo,4)/nbRegion),1);

spatialGlobalBDD = zeros(uint64(test_feature_info(nbvideo,4)/nbRegion),1);
temporalGlobalBDD = zeros(uint64(test_feature_info(nbvideo,4)/nbRegion),1);
MergeBDD = zeros(uint64(test_feature_info(nbvideo,4)/nbRegion),1);
originalMLresult = zeros(uint64(test_feature_info(nbvideo,4)/nbRegion),1);

videoFrame = zeros(nbvideo,2);


for ii = 1:nbvideo
    nbFrame = test_feature_info(ii,2);
    originalGlobal = zeros(nbFrame,1);
    pos_firstLable = test_feature_info(ii,4)-test_feature_info(ii,3)+1;
    pos_lastLable = test_feature_info(ii,4);
    current_CN= coeff_norm(pos_firstLable:pos_lastLable);
    currentLables = predicted_label(pos_firstLable:pos_lastLable);
    CNperROI_temp = reshape(current_CN,nbFrame,nbRegion);    
    CNperROI(:) = CNperROI_temp(1,:);
    lablePerROI = reshape(currentLables, nbFrame,nbRegion);
    dectPerVideo = lablePerROI';
    dist_video = vector2test(pos_firstLable:pos_lastLable,2:end);
   
    %%
    % original machine learning detection result
    for jj = 1: nbFrame
        for pp = 1:nbRegion
            if dectPerVideo(pp,jj)==1
                originalGlobal(jj) = 1 ;    
                break;
            end
        end        
    end
   
%% 
[temporalGlobal, temporalPerROI]= selectionPerROI(dist_video,dectPerVideo,nbFrame,nbRegion,window,seuil_indensity,CNperROI,r_w_ROI,cn_ratio);  
if spa_switch ==1
    [spatialGlobal,spatialPerROI] = roi2frame(dectPerVideo,temporalPerROI,nbFrame,nbRegion,pos_nose,nb_nose,pos_mouth,nb_mouth,window);
else 
    spatialGlobal = temporalGlobal;
    spatialPerROI = temporalPerROI;
end
spaTemGlobal = deleteSinglePeak(spatialGlobal,nbFrame,window,r_w_frame);
%spaTemGlobal = doMerge(spaTemGlobal,nbFrame,window);
mergepervideo = doMerge(originalGlobal,nbFrame,window);


 %%   fusion

    firstFrame = uint64(test_feature_info(ii,4)/nbRegion-test_feature_info(ii,2)+1);
    lastFrame = uint64(test_feature_info(ii,4)/nbRegion);
    detectionME(firstFrame:lastFrame) = spaTemGlobal;
    videoFrame(ii,:) = [firstFrame,lastFrame];
    
    temporalGlobalBDD(firstFrame:lastFrame) = temporalGlobal;
    spatialGlobalBDD(firstFrame:lastFrame) = spatialGlobal;
    originalMLresult(firstFrame:lastFrame)=originalGlobal;
    MergeBDD(firstFrame:lastFrame) = mergepervideo;

end
% end