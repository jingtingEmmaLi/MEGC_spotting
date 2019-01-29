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
for ii =1:nbSub
    if( isequal( subFiles( ii ).name, '.' )||...
        isequal( subFiles( ii ).name, '..')||...
        ~subFiles( ii ).isdir)              
        continue;
    end
    subName = subFiles(ii).name;
    if strcmp(bdd,'SAMM_cropped')
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
        
        %%  try to fusion more detected nearby intervals 
        % not not improve the result as expected because the TP is also
        % reduced
       
%         dd = 1;        
%         
%         new_merge = frameResult_vid;
%         new_interval = detect_interval;
%         interval_merge =[];
%         size(detect_interval)
%         while dd< size(detect_interval,1)
%              cc = 1;
%              sum_size = 0;
%              distBI = 0;
%              while distBI < 10 && dd+cc<= size(detect_interval,1)       
%                 distBI = detect_interval(dd+cc,1)- detect_interval(dd+cc-1,2);
%                 sum_size = sum_size + detect_interval(dd+cc,2)-detect_interval(dd+cc,1)+1;
%                 cc=cc+1;
%             end
%             if sum_size>set_inteval
%                 interval_merge = [interval_merge, dd:dd+cc-1] ;
%                 for ee = 0:cc-1
%                 new_merge(detect_interval(dd+ee,1):detect_interval(dd+ee,2))=0;
%                 
%                 end 
%             end
%             
%             dd = dd+cc;
%         end
%         frameResult_vid =new_merge; 
%         detect_interval(interval_merge,:) = [];
%         size(detect_interval)
        %%
        TP=0;
        FP=0;
        %%
        if strcmp(bdd,'SAMM_cropped')
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
            index_vid_me =[index_vid_me;curretVid];
            nb_gt = size(MEIndex_vid,1);
            for mm = 1:nb_gt
                onset = onsetInfo(MEIndex_vid(mm));
                
                offset= offsetInfo(MEIndex_vid(mm));
                
                if isempty(detect_interval)
                    TP=0;
                    FP=0;
                else 
                index_offset = find(detect_interval(:,1)<=offset);
                index_onset = find(detect_interval(:,2)>=onset);
                if ~isempty(index_offset) && ~isempty(index_onset)
                    k1 = index_offset(end);
                    k2 = index_onset(1);
                    nb2overlap =k1-k2;
                 
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
                    interval2delete_fp = [interval2delete_fp,k2:k1]; % here we try to try the interval beteen k2-k1 as one interval 
                    if ratio < ratio_threshold
                        FP = FP+1;
                    else
                        TP = TP+1;
                    end
                end 
                end
            end
            FN = nb_gt- TP;
        else 
            FN = 0;
        end
        detect_interval(interval2delete_fp,:) = [];
        nb_left_FP = size(detect_interval,1);
        FP = FP + nb_left_FP;  
        
        precison =  TP/nb_detect;
        f1_score = 2*TP / (2*TP+FP+FN);
        
        finalCompare = [finalCompare; TP, FP, FN, precison, f1_score]; 
curretVid = curretVid+1;
    end
    
end

    nbvid = size(finalCompare,1);
    
    final_ME = finalCompare(index_vid_me,:);
    nbvid_me = size(index_vid_me,1);
    mean_tp_me = sum(final_ME(:,1))/nbvid_me;
    mean_fp_me = sum(final_ME(:,2))/nbvid_me;
    mean_fn_me = sum(final_ME(:,3))/nbvid_me;
    mean_precison_me = sum(final_ME(:,4))/nbvid_me;
    mean_f1_score_me = sum(final_ME(:,5))/nbvid_me;
    TP_sum = sum(final_ME(:,1)); FP_sum = sum(final_ME(:,2)); FN_sum = sum(final_ME(:,3));
    precision_entireBDD = TP_sum/(TP_sum+FN_sum);
    f1_score_entireBDD = 2*TP_sum/(2*TP_sum+FP_sum+FN_sum);
    finalCompare_me = [final_ME; mean_tp_me, mean_fp_me, mean_fn_me, mean_precison_me, mean_f1_score_me;TP_sum,FP_sum,FN_sum,precision_entireBDD,f1_score_entireBDD ];
   
    
    
    
    mean_tp = sum(finalCompare(:,1))/nbvid;
    mean_fp = sum(finalCompare(:,2))/nbvid;
    mean_fn = sum(finalCompare(:,3))/nbvid;
    mean_precison = sum(finalCompare(:,4))/nbvid;
    mean_f1_score = sum(finalCompare(:,5))/nbvid;
    finalCompare = [finalCompare; mean_tp, mean_fp, mean_fn, mean_precison, mean_f1_score];
    
    save([outputSpot,'finalCompare_',num2str(set_inteval),'_',num2str(shortLength2delete),'.mat'],'finalCompare');
    save([outputSpot,'finalCompare_me_',num2str(set_inteval),'_',num2str(shortLength2delete),'.mat'],'finalCompare_me');