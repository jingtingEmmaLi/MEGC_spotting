%% fusion
function [originalMLresult,videoFrame] = initialGlobalDetect(predicted_label,test_feature_info,nbROI)
% info first colomn : video index
% info second colomn: frame number per video
% info third colomn : lable number per video
% info fourth colomn : accumulated lable number

nbvideo = size(test_feature_info,1);
nbRegion = size(nbROI,2);
originalMLresult = zeros(uint64(test_feature_info(nbvideo,4)/nbRegion),1);
videoFrame = zeros(nbvideo,2);

for ii = 1:nbvideo
    nbFrame = test_feature_info(ii,2);
    originalGlobal = zeros(nbFrame,1);
    pos_firstLable = test_feature_info(ii,4)-test_feature_info(ii,3)+1;
    pos_lastLable = test_feature_info(ii,4);
    currentLables = predicted_label(pos_firstLable:pos_lastLable);    
    lablePerROI = reshape(currentLables, nbFrame,nbRegion);
    dectPerVideo = lablePerROI';   
   
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
        firstFrame = uint64(test_feature_info(ii,4)/nbRegion-test_feature_info(ii,2)+1);
    lastFrame = uint64(test_feature_info(ii,4)/nbRegion);

    videoFrame(ii,:) = [firstFrame,lastFrame];
    originalMLresult(firstFrame:lastFrame)=originalGlobal;

end
% end