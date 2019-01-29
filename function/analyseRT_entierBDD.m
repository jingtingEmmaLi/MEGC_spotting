%% compare with groundtruth
function [nbGTetPOS,nbTPFPperVid,nbTPFPperFrame] = analyseRT_entierBDD(nbIntervalPt,label2one,window_lbp,detectionME,videoFrame,filename,newfileInfo,outputPath,drawSwitch)

nbvideo = size(videoFrame,1);
k = ceil((window_lbp-1)/4)
length_interval = nbIntervalPt+1;

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
    
    while jj<=nbFrame 
        if  onsetPCA>k && offset+k<=nbFrame
            if detectPerVideo(jj)==1 && jj>=onsetPCA-k  && jj<=offsetPCA+k
                jj = offsetPCA+k+1;
                nbTPFPperVid(ii,1)=1;        
            elseif detectPerVideo(jj)==1 && jj< onsetPCA-k 
                falsePstv = falsePstv+1;
                jj = jj + length_interval;
                if jj >onsetPCA-k
                    jj = onsetPCA-k;
                end
            elseif detectPerVideo(jj)==1 && jj> offsetPCA+k
                falsePstv = falsePstv+1;
                jj = jj + length_interval;  
            else
                jj=jj+1;
            end
        elseif onsetPCA<=k && onset >k  && offset+k<=nbFrame
            if detectPerVideo(jj)==1 && jj>=onset-k && jj<=offset+k
                jj = offset+k+1;
                nbTPFPperVid(ii,1)=1; 
            elseif detectPerVideo(jj)==1 && jj< onset-k 
                falsePstv = falsePstv+1;
                jj = jj + length_interval;
                if jj >onset-k
                    jj = onset-k;   
                end
            elseif detectPerVideo(jj)==1 && jj> offset+k
                falsePstv = falsePstv+1;
                jj = jj + length_interval; 
            else
                jj=jj+1;
            end
        elseif onset<=k
            if detectPerVideo(jj)==1 && jj<=offset+k
                jj = offset+k+1;
                nbTPFPperVid(ii,1)=1; 
            elseif detectPerVideo(jj)==1 && jj> offset+k
                falsePstv = falsePstv+1;
                jj = jj + length_interval; 
            else
                jj=jj+1;
            end
            
        elseif offset+k>nbFrame
            
            if detectPerVideo(jj)==1 && jj>=onset-k 
                jj = nbFrame;
                nbTPFPperVid(ii,1)=1;
            elseif detectPerVideo(jj)==1 && jj< onset-k 
                falsePstv = falsePstv+1;
                if jj + length_interval>= nbFrame
                    jj = nbFrame;
                else 
                    jj = jj + length_interval;                
                    if jj >=onset-k 
                        jj = onset-k;                
                    end
                end
            else
                jj=jj+1;
            end
        end
        if jj == nbFrame
                break;
        end
    end
    % nbTPFPperVid(ii,2) = falsePstv;
    if falsePstv>=1 && nbTPFPperVid(ii,1)==0
    nbTPFPperVid(ii,2) = 1;
    end
    
%%  detected frame numbers   
%    disp('perframe')
    jj=1;
    detect_nbFr = 0;
    fp_Fr = 0;
    while jj<=nbFrame
        if onsetPCA>k && offset+k<=nbFrame
            if detectPerVideo(jj)==1 && jj>=onsetPCA-k  && jj<=offset+k
                detect_nbFr = detect_nbFr+1;
            elseif (detectPerVideo(jj)==1 && jj< onsetPCA-k ) || (detectPerVideo(jj)==1 && jj> offsetPCA+k)
                fp_Fr = fp_Fr+1;
            end
        elseif onsetPCA<=k && onset >k && offset+k<=nbFrame
            if detectPerVideo(jj)==1 && jj>=onset-k && jj<=offset+k
                detect_nbFr = detect_nbFr+1;
            elseif (detectPerVideo(jj)==1 && jj< onset-k ) || (detectPerVideo(jj)==1 && jj> offset+k)
                fp_Fr = fp_Fr+1;
            end
            
        elseif onset<k
            if detectPerVideo(jj)==1 && jj<=offset+k
                detect_nbFr = detect_nbFr+1;
            elseif detectPerVideo(jj)==1 && jj> offset+k
                fp_Fr = fp_Fr+1;
            end
        elseif offset+k>nbFrame
            if detectPerVideo(jj)==1 && (jj>=onset-k || (jj>0 && onset-k<0) )
                detect_nbFr = detect_nbFr+1;
            elseif (detectPerVideo(jj)==1 && jj< onset-k ) 
                fp_Fr = fp_Fr+1;
            end
        end
            
        jj=jj+1;
    end
    nbTPFPperFrame(ii,:) = [detect_nbFr,fp_Fr];
    
    %% affichage
    if drawSwitch==1
    fig=figure;
    videoName = strrep(filename(ii),'_','\_'); 
    plot(groundTruth);
    hold on;
    plot(detectPerVideo);
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
