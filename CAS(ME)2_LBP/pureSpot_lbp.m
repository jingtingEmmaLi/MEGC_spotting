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
     disp(['processing ',vidIndex]); 
        outputChiSqDst_vid = [outputChiSqDst,subName,'/'] ;

        outputSpot_vid = [outputSpot,subName,'/'] ;
        createFold(outputSpot_vid);
      
        
        d_sorted =importdata([outputChiSqDst_vid,vidIndex,'_chiSquare_sorted.mat']);       
       
        posdetect = detectAvecSeuil_longVid(d_sorted,M,k,p);
        save([outputSpot_vid,vidIndex,'_posSpot.mat'],'posdetect');
        
        

        clear d_sorted  posdetect
    end
end
        
