%% fusion
function [originalMLresult,detectionME,detectionMEperROI,spatialGlobalBDD,spatialPerROIBDD,temporalGlobalBDD,temporalPerROIBDD,videoFrame,ratio_constraint] = fusionGlobal(vector2test,predicted_label,test_feature_info,nbROI,window,trueFileName,seuil_indensity,outputPath,switch_figure,switch_save)
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
detectionMEperROI = zeros(uint64(test_feature_info(nbvideo,4)/nbRegion),nbRegion);
spatialGlobalBDD = zeros(uint64(test_feature_info(nbvideo,4)/nbRegion),1);
temporalGlobalBDD = zeros(uint64(test_feature_info(nbvideo,4)/nbRegion),1);
temporalPerROIBDD =  zeros(uint64(test_feature_info(nbvideo,4)/nbRegion),nbRegion);
spatialPerROIBDD =  zeros(uint64(test_feature_info(nbvideo,4)/nbRegion),nbRegion);
originalMLresult = zeros(uint64(test_feature_info(nbvideo,4)/nbRegion),1);

videoFrame = zeros(nbvideo,2);
ratio_constraint =zeros(nbvideo,3);

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
    %% first spatial than temporal
% spatial selection
%     [spatialGlobal,spatialPerROI] = spatialSelection(CNperROI,dectPerVideo,nbFrame,nbRegion,pos_nose,nb_nose,pos_mouth,nb_mouth,window);    
%     % temperal selection directly from the original machine learning result
%     [temporalGlobal, temporalPerROI]= temporalFusion(CNperROI,dectPerVideo,nbFrame,nbRegion,window);   
%     disp('begin global fusion')
%     % temperal selection after the spatial selection
%     [spaTemGlobal, spaTemPerROI] = temporalFusion(CNperROI,spatialPerROI,nbFrame,nbRegion,window);  
% spaTemGlobal = doMerge(spaTemGlobal,nbFrame,window);
%% first temporal then spatial 22/01/2018
%     % temperal selection directly from the original machine learning result
%     [temporalGlobal, temporalPerROI]= temporalFiltrage(dist_video,dectPerVideo,nbFrame,nbRegion,window,seuil_indensity);   
%     % spatial selection
%     [spatialGlobal,spatialPerROI] = spatial2Global(CNperROI,dectPerVideo,nbFrame,nbRegion,pos_nose,nb_nose,pos_mouth,nb_mouth,window);    
%     disp('begin global fusion')
%     % temperal selection after the spatial selection
%     [spaTemGlobal, spaTemPerROI] = spatial2Global(CNperROI,temporalPerROI,nbFrame,nbRegion,pos_nose,nb_nose,pos_mouth,nb_mouth,window);   
% %     spaTemGlobal = doMerge(spaTemGlobal,nbFrame,window);
%%
    [temporalGlobal, temporalPerROI]= selectionPerROI(dist_video,dectPerVideo,nbFrame,nbRegion,window,seuil_indensity,CNperROI);   
    % spatial selection
    [spatialGlobal,spatialPerROI] = roi2frame(dectPerVideo,temporalPerROI,nbFrame,nbRegion,pos_nose,nb_nose,pos_mouth,nb_mouth,window);    disp('begin global fusion')
    % temperal selection after the spatial selection
    [spaTemGlobal, spaTemPerROI] = roi2frame(dectPerVideo,temporalPerROI,nbFrame,nbRegion,pos_nose,nb_nose,pos_mouth,nb_mouth,window);   
%     
   
 %%   fusion

if switch_save ==1
    if switch_figure == 1
        set(0,'DefaultFigureVisible', 'on')
    else 
        set(0,'DefaultFigureVisible', 'off')
    end
        fig =figure;
        subplot(4,2,1)
        plot(originalGlobal);
        title('Résultat originale');
        subplot(4,2,2)
        plot(originalGlobal);
        title('Résultat originale');
        subplot(4,2,4)
        plot(spatialGlobal);
        title('Résultat après la fusion spatiale');
        subplot(4,2,3)
        plot(temporalGlobal);
        title('Résultat après la sélection temporelle');
        subplot(4,2,[5,6])
         plot(originalGlobal);
        title('Résultat originale');
        subplot(4,2,[7,8])
        plot(spaTemGlobal);
        title('Résultat après les deux étapes de fusion globale');
 
        figureName = [outputPath,char(trueFileName(ii))];
        saveas(fig,[figureName,'_constraint_contribution'],'jpeg')
end  
        un_original = find(originalGlobal==1);
        nb_original = size(un_original,1);
        un_spatial = find(spatialGlobal==1);
        nb_spatial = size(un_spatial,1);
        un_temporal = find(temporalGlobal==1);
        nb_temporal = size(un_temporal,1);
        un_detect = find(spaTemGlobal==1);
        nb_detect = size(un_detect ,1);
       ratio_spatial = 1- nb_spatial/nb_original;
       ratio_temporal = 1- nb_temporal /nb_original;
       ration_fusion = 1-nb_detect/nb_original;
       ratio_constraint(ii,:) = [ratio_spatial,ratio_temporal,ration_fusion];
       
%     end
    firstFrame = uint64(test_feature_info(ii,4)/nbRegion-test_feature_info(ii,2)+1);
    lastFrame = uint64(test_feature_info(ii,4)/nbRegion);
    detectionME(firstFrame:lastFrame) = spaTemGlobal;
    detectionMEperROI(firstFrame:lastFrame,:)= spaTemPerROI';
    videoFrame(ii,:) = [firstFrame,lastFrame];
    
    temporalGlobalBDD(firstFrame:lastFrame) = temporalGlobal;
    spatialGlobalBDD(firstFrame:lastFrame) = spatialGlobal;
    temporalPerROIBDD(firstFrame:lastFrame,:) = temporalPerROI';
    spatialPerROIBDD(firstFrame:lastFrame,:) = spatialPerROI';
    originalMLresult(firstFrame:lastFrame)=originalGlobal;

end
% end