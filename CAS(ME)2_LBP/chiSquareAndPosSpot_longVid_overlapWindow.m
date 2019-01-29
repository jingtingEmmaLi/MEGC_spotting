%% fusion the detection result for SAMM database
%%
%configuration;



%%
for ii =1:nbSub
    if( isequal( subFiles( ii ).name, '.' )||...
        isequal( subFiles( ii ).name, '..')||...
        ~subFiles( ii ).isdir)              
        continue;
    end
    subName = subFiles(ii).name;
       
    vidFiles = dir([databasePath,subName,'/']);
    nbVid = length(vidFiles);
    for jj= 1:nbVid
        if( isequal( subFiles( jj ).name, '.' )||...
            isequal( subFiles( jj ).name, '..')||...            
            ~subFiles( jj ).isdir)               %
            continue;
        end
        
        vidIndex = vidFiles(jj).name;
        sub_vid_path = [subName,'/',vidIndex,'/'];
        vidPath = [databasePath,sub_vid_path];
        imgs  = dir([vidPath,'*.jpg']);
        nb_img = length(imgs);
        
        outputLBP_vid = [outputLBP,subName,'/'];       
        outputChiSqDst_vid = [outputChiSqDst,subName,'/'] ;
        createFold(outputChiSqDst_vid);
        outputSpot_vid = [outputSpot,subName,'/'] ;
        createFold(outputSpot_vid);
        
        indexWindowPath_vid = [indexWindowPath,subName,'/'];
        windowIndex = importdata([indexWindowPath_vid,vidIndex,'_indexWindow.mat']);
        charNames = importdata([indexWindowPath_vid,vidIndex,'_indexChar.mat']);


        nbClips = size(windowIndex,1);
        videoFrame = zeros(nbClips,2);

        detectionME=[];
        histEntierVideo = importdata([outputLBP_vid,vidIndex,'_lbp_uniform.mat']);
        disp(['processing ',vidIndex]); 

        for kk = 1:nbClips
            indexChar = charNames(kk,:);            
          
            
            firstFr = windowIndex(kk);
            lastFr = windowIndex(kk) + length_w -1;
            
            if lastFr>nb_img
                firstFr = windowIndex(kk-1);
                lastFr = nb_img;
            end
            %%
%             hist_clips = histEntierVideo(firstFr:lastFr,:,:,:);
%             
%             d_sorted = chiSquareDst_longVid(hist_clips,k);       
%             save([outputChiSqDst_vid,vidIndex,indexChar,'_chiSquare_sorted.mat'],'d_sorted') ; 
            %%
            d_sorted = importdata([outputChiSqDst_vid,vidIndex,indexChar,'_chiSquare_sorted.mat']) ; 
        
            posdetect = detectAvecSeuil_longVid(d_sorted,M,k,p);           
            detectionME = [detectionME;posdetect];   
            videoFrame(kk,2) = size(detectionME,1);
            if kk == 1
                videoFrame(kk,1) = 1;
            else 
            videoFrame(kk,1) = videoFrame(kk-1,2)+1;
            end 
        end
        clear histEntierVideo


        frameResult = zeros(nb_img,1);
        
        for kk = 1:nbClips  
            fstFrame = videoFrame(kk,1);
            lstFrame = videoFrame(kk,2);
            realLastFrame = windowIndex(kk)+ lstFrame-fstFrame;
            nbFig = lstFrame-fstFrame+1;
            detectSeq = detectionME(fstFrame:lstFrame) ;
            %detectNextSeq = detectionME(lstFrame+1:videoFrame(kk+1,2))
            if kk <=nbClips-1
                for nn = windowIndex(kk): realLastFrame
                    curtPos = nn-windowIndex(kk)+1;
                    if nn <= realLastFrame-overlap 
                        frameResult(nn) = detectSeq(curtPos);
                
                    else  
                        if detectSeq(curtPos)==0 && detectionME(lstFrame+curtPos+overlap-nbFig)==0
                            frameResult(nn)=0;
                        else
                            frameResult(nn) =1;
                        end
                    end
                end
            else
                frameResult(windowIndex(kk)+overlap: realLastFrame) = detectSeq(overlap+1:end);
            end         
        
        end
            save([outputSpot_vid,vidIndex,'_posSpot.mat'],'frameResult');
        
        ii
        jj
    end
   
end


