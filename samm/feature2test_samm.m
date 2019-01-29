% This file is to build feature to test 
% the feature is build based on clips which are seperated in one video.
% i.e. for one video, we have several clips --> several features to test 
% then for the subject, at last for the entire database
% output:
% &feature for clips saved in each video file
% &featureSize
% the label is not necessairy because there will be a fusion for entire
% video.
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
    %indexSub= find(sammMEinfo(:,1)==str2double(subName));
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
        indexWindowPath_vid = [indexWindowPath,subName,'/'];
        windowIndex = importdata([indexWindowPath_vid,vidIndex,'_indexWindow.mat']);
        charNames = importdata([indexWindowPath_vid,vidIndex,'_indexChar.mat']);
        distanceNormPath_vid=[distanceNormPath,sub_vid_path];
        nbClips = size(windowIndex,1);
        clipsInfo = zeros(nbClips,2);
        vecto2testPath_vid = [vecto2testPath,sub_vid_path];
        createFold(vecto2testPath_vid);
        for kk = 1:nbClips
            distance_clip = [];
            indexChar = charNames(kk,:);            
            for nn= 1:nbRegion
                RoiLm = nbROI(nn);
                distance_roi = importdata([distanceNormPath_vid,indexChar,'_',num2str(RoiLm),'_dst_norm.mat']);
                nbFrame = size(distance_roi,1);
                distance_clip = [distance_clip;distance_roi];
            end
            vecSize = size(distance_clip,1);
            if vecSize~=nbRegion*nbFrame
                sub_vid_path
                kk
                break;
            end
            clipsInfo(kk,:)=[nbFrame,vecSize] ;         
            save([vecto2testPath_vid,indexChar,'_vec2test.mat'],'distance_clip')
        end
        save([indexWindowPath_vid,vidIndex,'_clipsInfo.mat'],'clipsInfo');        
        ii
        jj
    end
   
 end
 