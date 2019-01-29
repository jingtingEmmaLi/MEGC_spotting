function drawEachStepContribution(nbGTetPOS,originalMLresult,detectionME,temporalGlobalBDD,spatialGlobalBDD,MergeBDD,videoFrame,nbVideo,outputPath,trueFileName,switch_save,switch_figure)
for ii = 1:nbVideo
    firstFr = videoFrame(ii,1);
    lastFr = videoFrame(ii,2);
    nbFrame = lastFr-firstFr+1;
    originalGlobal = originalMLresult(firstFr:lastFr);
    onset_gt = nbGTetPOS(ii,2);
   offset_gt = nbGTetPOS(ii,3);
   groundtruth = zeros(nbFrame,1);
   groundtruth(onset_gt:offset_gt)=1;
    
    spaTemGlobal = detectionME(firstFr:lastFr);
    temporalGlobal=temporalGlobalBDD(firstFr:lastFr);
    spatialGlobal=spatialGlobalBDD(firstFr:lastFr);
    mergepervideo=MergeBDD(firstFr:lastFr);
if ii ==3 
    ii
if switch_save ==1
    if switch_figure == 1
        set(0,'DefaultFigureVisible', 'on')
    else 
        set(0,'DefaultFigureVisible', 'off')
    end
        fig =figure;
        subplot(5,1,1)
        plot(originalGlobal,'b');
        hold on
        plot(groundtruth,'r');
        axis([0 nbFrame 0 1.2]);
        title('Résultat original global (RL)');
%         title('Original global result (LR)');
        subplot(5,1,2)
        plot(temporalGlobal,'b');
        hold on 
         plot(groundtruth,'r');
         axis([0 nbFrame 0 1.2]);
        title('Qualification locale : RL->QL');
%         title('Local qualification : LR->LQ');
        subplot(5,1,3)
        plot(spatialGlobal,'b');
        hold on
        plot(groundtruth,'r');
        axis([0 nbFrame 0 1.2]);
%         title('Spatial fusion : LR->SF');
        title('Fusion spatiale : RL->FS');
        subplot(5,1,4)
        plot(mergepervideo,'b');
        hold on;
       plot(groundtruth,'r');
       axis([0 nbFrame 0 1.2]);
%         title('Merge process : LR->MG');
       title('Lissage : RL->LG');
        subplot(5,1,5)
        plot(spaTemGlobal,'b');
        hold on;
         plot(groundtruth,'r');
         axis([0 nbFrame 0 1.2]);
        title('Fusion globale (FG) : RL->QL+FS+LG');
%         title('Global fusion (GF) : LR->LQ+SF+MG');
        
 
        figureName = [outputPath,char(trueFileName(ii))];
        saveas(fig,[figureName,'_constraint_contribution_gt_fr.eps'],'psc2')
end
end
end