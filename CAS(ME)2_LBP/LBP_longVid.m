%% LBP feature difference for entier CASME1 SectionA
% fisrt part -LBP histogram generation

%%

%%
for ii =1:nbSub
    if( isequal( subFiles( ii ).name, '.' )||...
        isequal( subFiles( ii ).name, '..')||...
        ~subFiles( ii ).isdir)              
        continue;
    end
    subName = subFiles(ii).name;
    vidFiles = dir([outputLMpath,subName,'/']);
    nbVid = length(vidFiles);
    for jj= 1:nbVid
        if( isequal( subFiles( jj ).name, '.' )||...
            isequal( subFiles( jj ).name, '..')||...            
            ~subFiles( jj ).isdir)               %
            continue;
        end
        indexWindow=[];
        vidIndex = vidFiles(jj).name;
        sub_vid_path = [subName,'/',vidIndex,'/'];
        facePath = [databasePath,sub_vid_path];
        LMpath_vid = [outputLMpath,sub_vid_path];
        blockVidPath =[BlockupperPath,subName,'/'] ;
        outputLBP_vid = [outputLBP,subName,'/'];
        createFold(outputLBP_vid);
        blockImageSet = importdata([blockVidPath,vidIndex,'_blockVid.mat']);
        [nbFrame, nbBlock,~,~] = size(blockImageSet);
        for pp = 1:nbFrame
            for qq = 1: nbBlock
                clear image2lbp;
                image2lbp(:,:) = blockImageSet(pp,qq,:,:);      % for each video and each ROI, begin to calculate the LBP feature per frame
                mapping = getmapping(nbSamples,type);
                lbpHist = lbp(image2lbp,radius,nbSamples,mapping,modeHist);
                [n,m]= size(lbpHist);
                if pp == 1 && qq==1
                    [n,m]= size(lbpHist);
                     histEntierVideo = zeros(nbFrame,nbBlock,n,m);
                end
                histEntierVideo(pp,qq,:,:) = lbpHist; 
            end                
        end
        save([outputLBP_vid,vidIndex,'_lbp_uniform.mat'],'histEntierVideo')
        clear blockImageSet 
    end
end
        
