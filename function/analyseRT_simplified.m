%% compare with groundtruth
function [nbGTetPOS,nbTPFPperVid,nbTPFPperFrame] = analyseRT_simplified(nbIntervalPt,label2one,window_lbp,detectionME,videoFrame,filename,newfileInfo,outputPath,drawSwitch)

nbvideo = size(videoFrame,1);
k = ceil((window_lbp-1)/4);
length_interval = nbIntervalPt*2;

nbGTetPOS = zeros(nbvideo,3);
nbTPFPperFrame = zeros(nbvideo,2);
nbTPFPperVid = zeros(nbvideo,2);


for ii = 1:nbvideo
   
    nbFrame = newfileInfo(ii,1);
    
    groundTruth = zeros(nbFrame,3);    
    onset = newfileInfo(ii,2);
    offset = newfileInfo(ii,3);  
    
    onsetPCA = onset-label2one;
    offsetPCA = offset-label2one;
     
    firstFrame = videoFrame(ii,1);
    lastFrame = videoFrame(ii,2);
    
    detectPerVideo = detectionME(firstFrame:lastFrame);
    %% ground truth setting
%     disp('groundtruth')
    if nbFrame < 2*k+1 %special situation for too short video
           k = ceil(k/2);
    end
    if  onsetPCA>k  &&  offset+k<=nbFrame 
%         disp('1')
        groundTruth(onsetPCA-k:offsetPCA+k) = 1;
        nbGTetPOS(ii,1) = offsetPCA - onsetPCA+2*k+1;
        nbGTetPOS(ii,2:3) = [onsetPCA-k,offsetPCA+k];
    elseif onsetPCA<=k && onset >k  && offset+k<=nbFrame   
%         disp('2')
         groundTruth(onset-k:offset+k) = 1;
        nbGTetPOS(ii,1) = offset- onset+2*k+1;
        nbGTetPOS(ii,2:3) = [onset-k,offset+k];
    elseif onset<=k 
%         disp('3')
        groundTruth(1:offset+k) = 1; 
        nbGTetPOS(ii,1) = offset+k ;
        nbGTetPOS(ii,2:3) = [1,offset+k];   
    elseif offset+k>nbFrame   
%         disp('4')
        groundTruth(onset-k:nbFrame) = 1; 
        nbGTetPOS(ii,1) = nbFrame-onset+k+1 ;
        nbGTetPOS(ii,2:3) = [onset-k,nbFrame];
     end
    
%% detection number per video
    jj=1;
    falsePstv = 0;
%     disp('per video')
   onset_gt = nbGTetPOS(ii,2);
   offset_gt = nbGTetPOS(ii,3);
    while jj<=nbFrame         
            if detectPerVideo(jj)==1 && jj>=onset_gt && jj<=offset_gt
                jj = offset_gt+1;
                nbTPFPperVid(ii,1)=1;        
            elseif detectPerVideo(jj)==1 && jj< onset_gt
                kk = 1;
                pasGT = 1;
                while detectPerVideo(jj+kk)==1
                    if jj+kk>=onset_gt
                        pasGT = 0;
                        break
                    end
                    kk=kk+1;
                end
                if pasGT == 1
                falsePstv = falsePstv+1;                
                jj = jj + length_interval;
                else
                    jj = offset_gt+1;
                end
                if jj >onset_gt
                    jj = onset_gt;
                end
            elseif detectPerVideo(jj)==1 && jj> offset_gt
                kk = 1;
                pasGT = 1;
                while detectPerVideo(jj-kk)==1
                    if jj-kk<=offset_gt
                        pasGT = 0;
                        break
                    end
                    kk=kk+1;
                end
                if pasGT == 1
                falsePstv = falsePstv+1;
                end
                jj = jj + length_interval;  
            else
                jj=jj+1;
            end
        
        if jj == nbFrame
                break;
        end
    end
     nbTPFPperVid(ii,2) = falsePstv;
%     if falsePstv>=1 && nbTPFPperVid(ii,1)==0
%         nbTPFPperVid(ii,2) = 1;
%     end
%     
%%  detected frame numbers   
%    disp('perframe')
    detect_nbFr = 0;
    fp_Fr = 0;
    for jj =1:nbFrame
        if detectPerVideo(jj)==1 && jj>=onset_gt  && jj<=offset_gt
            detect_nbFr = detect_nbFr+1;
        elseif (detectPerVideo(jj)==1 && jj< onset_gt ) || (detectPerVideo(jj)==1 && jj> offset_gt)
            fp_Fr = fp_Fr+1;
        end
    end
    nbTPFPperFrame(ii,:) = [detect_nbFr,fp_Fr];
    
    %% affichage
    if drawSwitch==1
    fig=figure;
    set(0,'DefaultFigureVisible', 'off')
    videoName = strrep(filename(ii),'_','\_'); 
    x1 = [onset_gt,onset_gt];x2 = [offset_gt,offset_gt];
    y = [0,1];
    plot(x1,y,'r');hold on; plot(x2,y,'r');hold on;
%     plot(groundTruth,'r');
%     hold on;
    plot(detectPerVideo,'b');
    title(videoName);
    hold off
    
    figureName = [outputPath,char(filename(ii))];
    
    saveas(fig,figureName); 
    saveas(fig,figureName,'jpeg'); 
    close
    end
 clear onset offset    
end



% end
