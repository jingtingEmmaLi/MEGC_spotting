function getDistanceAndNormlzd(Vs_entier,nbROI,nbLm,indexChar,nb2max,ME_interval,distancePath,distanceNormPath,CN_seuil)      
for nn = 1:nbLm
    %% import data from different ROI 
    RoiLm = nbROI(nn);
    %disp(['ROI: ',num2str(RoiLm)]);
    %Vs = importdata([outPCApath,fileSub,num2str(RoiLm),'_PCA_Vs.mat']);  
    Vs = Vs_entier(:,:,nn);
    %% region choisi ?comparer
    nbframe = size(Vs(:,1:2),1);
    nbInterval = nbframe;  
    distancePerFrame = zeros(nbframe,ME_interval);
    for posIntval = 1: nbInterval
        distance = displayDistanceBy1stFr(ME_interval,Vs(:,1:2),posIntval); 
        distancePerFrame(posIntval,:) = distance;
    end
    %disp('save distance value')
    save([distancePath,indexChar,'_',num2str(RoiLm),'_dst.mat'],'distancePerFrame');
    %%
    max_dist = max(max(distancePerFrame(:,1:nb2max)));
    norm_dist = distancePerFrame./max_dist;
    if isempty(CN_seuil)
        coff_norm = 1/max_dist;
    else
        coff_norm =min(CN_seuil, 1/max_dist);
    end
    [m,n] = size(norm_dist);
    norm_dist_coff = zeros(m,n+1);
    norm_dist_coff(:,1) = coff_norm;
    norm_dist_coff(:,2:n+1) = norm_dist;
    save([distanceNormPath,indexChar,'_',num2str(RoiLm),'_dst_norm.mat'],'norm_dist_coff');
    
    clear Vs distancePerFrame
end
end
   
