%% fusion the detection result for SAMM database
%%
%configuration;

[~,~,raw] = xlsread(inputXlS);

%%
for ii =1:nbSub
    if( isequal( subFiles( ii ).name, '.' )||...
        isequal( subFiles( ii ).name, '..')||...
        ~subFiles( ii ).isdir)              
        continue;
    end
    subName = subFiles(ii).name;
    if strcmp(bdd,'SAMM')
    indexSub= find(sammMEinfo(:,1)==str2double(subName));
    elseif strcmp(bdd,'CAS(ME)2')
        nbvid = size(casMEinfo,1);
        indexSub = [];
        nbvid = size(casMEinfo,1);
        for xx= 1:nbvid
            if strcmp(raw{xx,1},subName)
                indexSub = [indexSub;xx];
            end
        end
    end
    
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
        indexWindowPath_vid = [indexWindowPath,subName,'/'];
        windowIndex = importdata([indexWindowPath_vid,vidIndex,'_indexWindow.mat']);
        charNames = importdata([indexWindowPath_vid,vidIndex,'_indexChar.mat']);
        clipsInfo = importdata([indexWindowPath_vid,vidIndex,'_clipsInfo.mat']);
        vecto2testPath_vid = [vecto2testPath,sub_vid_path];
        nbClips = size(windowIndex,1);
        
        predictLabelPath_vid = [predictLabelPath,sub_vid_path];
        
        data2test =[];
        predicted_label=[];
        testFeatureInfo = zeros(size(clipsInfo,1),4);
        testFeatureInfo(:,2:3) = clipsInfo;
        for kk = 1:nbClips
            indexChar = charNames(kk,:);            
            vec2test = importdata([vecto2testPath_vid,indexChar,'_vec2test.mat']);        
            predicted_label_clip = importdata([predictLabelPath_vid,indexChar,trainVecComposition,'_predictLabel.mat']);
            data2test = [data2test; vec2test];
            predicted_label = [predicted_label;predicted_label_clip];           
            
            testFeatureInfo(kk,1) = kk;
            testFeatureInfo(kk,4) = size(data2test,1);
        end
        [originalMLresult,detectionME,temporalGlobalBDD,spatialGlobalBDD,MergeBDD,videoFrame] = ...
        fusionbyCNdist(data2test,predicted_label,testFeatureInfo,nbROI,window,seuil_indensity,spa_switch,r_w_ROI,cn_ratio,r_w_frame);
        fusionPath_sub = [fusionPath,subName,'/' ];
        createFold(fusionPath_sub); 
        save([fusionPath_sub,vidIndex,'finalGlobalResult',trainVecComposition,'.mat'],'detectionME'); 
        save([fusionPath_sub,vidIndex,'originalMLresult',trainVecComposition,'.mat'],'originalMLresult'); 
        save([fusionPath_sub,vidIndex,'temporalGlobalBDD',trainVecComposition,'.mat'],'temporalGlobalBDD'); 
        save([fusionPath_sub,vidIndex,'spatialGlobalBDD',trainVecComposition,'.mat'],'spatialGlobalBDD');
        save([fusionPath_sub,vidIndex,'MergeBDD',trainVecComposition,'.mat'],'MergeBDD');  
       % drawEachStepFusionSansGT(originalMLresult,detectionME,temporalGlobalBDD,spatialGlobalBDD,MergeBDD,videoFrame,...
    %    nbSeq,outputPath,indexChar,1,1);


        frameResult = zeros(nb_img,1);
        frameRoiResult = zeros(nb_img,nbRegion);
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
        save([fusionPath_sub,vidIndex,'finalFrameResult',trainVecComposition,'.mat'],'frameResult');
        
        ii
        jj
    end
   
end


