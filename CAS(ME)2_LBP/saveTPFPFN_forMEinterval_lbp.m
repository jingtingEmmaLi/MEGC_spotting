% compare result with groundtruth
% here for our mehthod the ground truth need to move forward for label2one
% positions
% output:
% &overlap rate for true positive per video per ground truth
% &true positive per video
% &false positive per video
% &false negative per video
% &precision per video
% &F1-SCORE per video
% &all these five metrics for entire database
% 

%%
%configuration;
%%
% getting ground truth same as feature to train

[~,~,raw] = xlsread(inputXlS);


finalCompare = [];
index_vid_me = [];
curretVid = 1;
ME_info = [];
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
     outputSpot_vid = [outputSpot,subName,'/'];
    nbVid = length(vidFiles);
    for jj= 1:nbVid
        if( isequal( subFiles( jj ).name, '.' )||...
            isequal( subFiles( jj ).name, '..')||...            
            ~subFiles( jj ).isdir)               %
            continue;
        end
        
        vidIndex = vidFiles(jj).name;
        sub_vid_path = [subName,'/',vidIndex,'/'];     
        
        frameResult_vid = importdata([outputSpot_vid,vidIndex,'_posSpot.mat']);
        nbFrame = size(frameResult_vid,1);
        %% merge result and delete too short interval
        pp = 1;
        detect_interval = [];
        while pp<=nbFrame
            if pp+set_inteval-1<= nbFrame
                indexPositive = find(frameResult_vid(pp:pp+set_inteval-1));
            else
                indexPositive = find(frameResult_vid(pp:nbFrame));
            end
            indexreal = indexPositive+pp-1;
            if size(indexPositive,1)<shortLength2delete 
                frameResult_vid(indexreal)=0;                
            else
                frameResult_vid(indexreal(1):indexreal(end))=1; 
                detect_interval = [detect_interval; indexreal(1),indexreal(end)];
            end            
            pp = pp+set_inteval ;         
        end
        nb_detect = size(detect_interval,1);
        

        %%
        TP=0;
        FP=0;
        %%
        if strcmp(bdd,'SAMM')
            MEIndex_vid = find(sammMEinfo(indexSub,2)==str2double(vidIndex));
            onsetInfo = sammMEinfo(indexSub,3);
             offsetInfo = sammMEinfo(indexSub,5);
        elseif strcmp(bdd,'CAS(ME)2')
            MEIndex_vid = [];
            nbME = size(indexSub,1);
            for yy = 1:nbME
                if strcmp(raw{indexSub(yy),2},vidIndex)
                MEIndex_vid = [MEIndex_vid;yy];
                end
            end
            onsetInfo = casMEinfo(indexSub,1);    
            offsetInfo = casMEinfo(indexSub,3);
        end
        
        
        
        interval2delete_fp = [];
        
        if ~isempty(MEIndex_vid)
            
            nb_gt = size(MEIndex_vid,1);
            me_info_vid= zeros(nb_gt,9);
            me_info_vid(:,1) = ii;
            me_info_vid(:,2) = jj;
            me_info_vid(:,3) = 1:nb_gt;
            
            for mm = 1:nb_gt                
                onset= onsetInfo(MEIndex_vid(mm));
                
                offset = offsetInfo(MEIndex_vid(mm));
                
                if isempty(detect_interval)
                    TP=0;
                    FP=0;
                else 
                index_offset = find(detect_interval(:,1)<=offset);
                index_onset = find(detect_interval(:,2)>=onset);
                if ~isempty(index_offset) && ~isempty(index_onset)
                    me_info_vid(mm,4) = 1;
                    k1 = index_offset(end);
                    k2 = index_onset(1);
                    nb2overlap =k1-k2;
                    me_info_vid(mm,6:9) = [onset,offset,detect_interval(k2,1),detect_interval(k1,2)];
                 
                    u_left = min(onset,detect_interval(k2,1));
                    u_right = max(offset,detect_interval(k1,2));
                    i_left = max(onset,detect_interval(k2,1));
                    i_right = min(offset,detect_interval(k1,2));
                    frame2delete = 0;
                    if nb2overlap>=1
                        for aa = 1:nb2overlap
                            frame_between = detect_interval(aa+k2,1)-detect_interval(aa+k2-1,2)+1;
                            frame2delete = frame2delete+ frame_between;   
                        end                
                    end
                    ratio = (i_right-i_left-frame2delete+1)/(u_right-u_left);
                     % here we try to treat the interval beteen k2-k1 as one interval 
                    if ratio < ratio_threshold
                       me_info_vid(mm,5) = 0; 
                        
                    else
                      me_info_vid(mm,5) = 1; 
                    end
                else
                     me_info_vid(mm,4) = 0;
                     me_info_vid(mm,5) = -1; 
                     me_info_vid(mm,6:9) = [onset,offset,-1,-1];
                end
                end
            end
          
        ME_info = [ME_info;me_info_vid];
           
        end
       
                
       
    end    
end
save([outputSpot,'MEinterval_info_',num2str(set_inteval),'_',num2str(shortLength2delete),'.mat'],'ME_info');
   