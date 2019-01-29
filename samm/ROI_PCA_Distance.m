%% initialisation
% configuration;

for ii =15:17% 1:nbSub
    if( isequal( subFiles( ii ).name, '.' )||...
        isequal( subFiles( ii ).name, '..')||...
        ~subFiles( ii ).isdir)              
        continue;
    end
    subName = subFiles(ii).name;
    vidFiles = dir([databasePath,subName,'/']);
    nbVid = length(vidFiles);
    for jj=1:nbVid
        if( isequal( subFiles( jj ).name, '.' )||...
            isequal( subFiles( jj ).name, '..')||...            
            ~subFiles( jj ).isdir)               %
            continue;
        end
        indexWindow=[];
        vidIndex = vidFiles(jj).name;
        sub_vid_path = [subName,'/',vidIndex,'/'];
        vidPath = [databasePath,sub_vid_path];
        LMpath_vid = [outputLMpath,sub_vid_path];
        imgs = dir([vidPath,'*.jpg']);
        
        LMs = dir([LMpath_vid,'*.txt']);
        nbFrame = length(LMs);
        kk=1;%1
        while kk <= nbFrame
            if kk+length_w-1 <= nbFrame
                fstFr = kk;
                lastFr = kk+length_w-1;
            else
                if  nbFrame - kk >= ME_interval
                    fstFr = kk;
                    lastFr =nbFrame ;
                else
                    fstFr = kk-length_w + overlap;
                    lastFr =nbFrame ;
                end
            end
            
            posRoiTxt = textread([LMpath_vid,LMs(kk).name]);% all depending on the first frame
            if posRoiTxt(1,1) <=0 && posRoiTxt(2,1) <=0 
                posRoiTxt = textread([LMpath_vid,LMs(kk+1).name]);
            end
            lengthTxt = size(posRoiTxt,1);
            posRoi = zeros(lengthTxt/2,2);
            for pp = 1:lengthTxt/2
               posRoi(pp,1) = posRoiTxt(2*pp-1) ;
               posRoi(pp,2) = posRoiTxt(2*pp) ;
            end
            resultname = regexp(imgs(fstFr).name,'.j','split');
            indexChar = char(resultname(1));
            % cut the ROI image
            ROIupperPath_vid=[ROIupperPath,sub_vid_path];
            createFold(ROIupperPath_vid);
            roiImgAll = getROIper1stFr(vidPath,fstFr,lastFr,sizeROI,posRoi,imgs,nbROI,nbRegion ,indexChar,ROIupperPath_vid);
            % apply PCA on PCA
            outPCApath_vid=[outPCApath,sub_vid_path];
            createFold(outPCApath_vid);
            Vs_entier=getPCAperROIclips(roiImgAll,nbROI,nbRegion ,indexChar,outPCApath_vid,variance_expliquee);
            % get distance and normalized
            distancePath_vid=[distancePath,sub_vid_path];
            createFold(distancePath_vid);
            distanceNormPath_vid=[distanceNormPath,sub_vid_path];
            createFold(distanceNormPath_vid);
            getDistanceAndNormlzd(Vs_entier,nbROI,nbRegion ,indexChar,nb2max,ME_interval,distancePath_vid,distanceNormPath_vid,CN_seuil) ;  
            indexWindow = [indexWindow;kk];
            kk = kk+length_w-overlap;
            ii
            jj
            kk
        end
        indexWindowPath_vid = [indexWindowPath,subName,'/'];
        createFold(indexWindowPath_vid);
        save([indexWindowPath_vid,vidIndex,'_indexWindow.mat'],'indexWindow');
    end
   
 end
 