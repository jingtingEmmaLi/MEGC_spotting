%% afficher les resultats de PCA
function Vs_entier=getPCAperROIclips(roiImgAll,nbROI,nbLm,indexChar,outPCApath,variance_expliquee)
[l_roi,~, nbFrame, ~] = size(roiImgAll);
Vs_entier = zeros(nbFrame,l_roi^2,nbLm);
 for nn = 1:nbLm
     %% import data from different ROI 
     RoiLm = nbROI(nn);
     %disp(['ROI: ',num2str(RoiLm)]);
     %inputPath = [ROIupperPath,fileSub,num2str(RoiLm),'_ROIper1stFr.mat'];
     %videoTemp = importdata(inputPath); 
     [video2Pca,nbFrame]= transformVideo(roiImgAll(:,:,:,nn)); % video2Pca should be nbFrame*nbPixel   

     %% PCA
    % disp('PCA begin')
     clear Diag Vs 
     meanVideo = mean(video2Pca);
     temp_mean = repmat(meanVideo,nbFrame,1);
     video2Pca_centre = video2Pca - temp_mean;
     [Diag,Vs,energie,~,~] = slg_acp(video2Pca_centre,nbFrame,variance_expliquee);
     %disp('save PCA result')
     save([outPCApath,indexChar,'_',num2str(RoiLm),'_PCA_Vs.mat'],'Vs'); 
     save([outPCApath,indexChar,'_',num2str(RoiLm),'_PCA_energie.mat'],'energie'); 
     Vs_entier(:,:,nn) = Vs;
 end
        
end 
