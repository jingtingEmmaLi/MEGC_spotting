

%%
function distance_variation_nearOnset(currentVideo,nbROI,distanceNormPath)
i = currentVideo;
disp(['-------begin to treat ',num2str(i),' video sequence--------']);
%import info and generate the video sequence
[nbSub, nbEP, onset, ~, ~] = xlsImport(inputXls,i);
fileSub = [nbSub,'_',nbEP,'_',mode,'_size_',num2str(sizeROI*sizeROI),'_ROI_'];
for nn = 1:size(nbROI,2)
    %% import data from different ROI 
    RoiLm = nbROI(nn);
    if ismember(RoiLm,[5,6])==0
        continue;
    else
        disp(['ROI: ',num2str(RoiLm)]);
        ensemble_norm = importdata([distanceNormPath,fileSub,num2str(RoiLm),'_dst_norm.mat']);
        norm_dist = ensemble_norm(:,2:end);
        figure;
        for kk = 1:8                
            subplot(4,4,kk);
            plot(norm_dist(onset-4+kk,:));
            %axis([0 19 -1 1] );
            if kk ==1
                figName = strrep([nbSub,'_',nbEP,'_',num2str(RoiLm)],'_','\_');
                title(figName);
            end
            if kk==4
                title(['onset=',num2str(onset)]);
            end
        end
        [~, indRow, ~] = findMax(norm_dist);
        for kk = 9:16
            subplot(4,4,kk);
            plot(norm_dist(indRow+kk-8,:));
            % axis([0 19 -1 1] );
            
            if kk==9
                title(num2str(indRow));
            end
        end
    end
end
  
   
