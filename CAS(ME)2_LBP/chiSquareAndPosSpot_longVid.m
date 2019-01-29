%% LBP feature difference 
% second part -chi Square distance calculate
% third  part - pos spotting - threshold selection
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
        outputLBP_vid = [outputLBP,subName,'/'];       
        outputChiSqDst_vid = [outputChiSqDst,subName,'/'] ;
        createFold(outputChiSqDst_vid);
        outputSpot_vid = [outputSpot,subName,'/'] ;
        createFold(outputSpot_vid);
        
        histEntierVideo = importdata([outputLBP_vid,vidIndex,'_lbp_uniform.mat']);
        disp(['processing ',vidIndex]); 
        
        d_sorted = chiSquareDst_longVid(histEntierVideo,k);       
        save([outputChiSqDst_vid,vidIndex,'_chiSquare_sorted.mat'],'d_sorted') ; 
        
        posdetect = detectAvecSeuil_longVid(d_sorted,M,k,p);
        save([outputSpot_vid,vidIndex,'_posSpot.mat'],'posdetect');
        
        

        clear histEntierVideo d_sorted  posdetect
    end
end
        
