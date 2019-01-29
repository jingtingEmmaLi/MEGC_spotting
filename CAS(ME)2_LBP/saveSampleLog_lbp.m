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
fid= fopen([outputSpot,'sampleLog_lbp.txt'],'w');
ME_info = importdata([outputSpot,'MEinterval_info_',num2str(set_inteval),'_',num2str(shortLength2delete),'.mat']);
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
    
    ME_info_sub_index =find(ME_info(:,1)==ii);
    ME_info_sub = ME_info(ME_info_sub_index,:);
    for jj= 1:nbVid
        if( isequal( subFiles( jj ).name, '.' )||...
            isequal( subFiles( jj ).name, '..')||...            
            ~subFiles( jj ).isdir)               %
            continue;
        end
        
        vidIndex = vidFiles(jj).name;
        sub_vid_path = [subName,'/',vidIndex,'/'];     
        vid2txt = [subName,'_',vidIndex];
        frameResult_vid = importdata([outputSpot_vid,vidIndex,'_posSpot.mat']);
        nbFrame = size(frameResult_vid,1);
        
        ME_info_vid_index =find(ME_info_sub(:,2)==jj);
        ME_info_vid = ME_info(ME_info_vid_index,:);
        
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
        
        if isempty(ME_info_vid)
%             for nn = 1:nb_detect
%                 fr_begin = detect_interval(nn,1);
%                 fr_end = detect_interval(nn,2);
%                 fprintf(fid,'%s %s %s %d %d %s\r\n', vid2txt,'-','-',fr_begin,fr_end,'FP');
%             end
        else
            nb_gt = size(MEIndex_vid,1);
            for mm = 1:nb_gt
                onset= onsetInfo(MEIndex_vid(mm));
                
                offset = offsetInfo(MEIndex_vid(mm));
                
                
               % ---------all the fp out of ME interval-----
                if mm== 1
                    index_out_me_end = find(detect_interval(:,2)<onset);  
                    if ~isempty(index_out_me_end)
                    for nn = 1: size(index_out_me_end,1)                   
                        fr_begin = detect_interval(index_out_me_end(nn),1);
                        fr_end = detect_interval(index_out_me_end(nn),2);
                        fprintf(fid,'%s %s %s %d %d %s\r\n', vid2txt,'-','-',fr_begin,fr_end,'FP');           
                    end 
                    end
                else 
                    index_out_me_end = find(detect_interval(:,2)<onset);
                    index_out_me_begin = find(detect_interval(:,1)>offsetInfo(MEIndex_vid(mm-1))); 
                    if ~isempty(index_out_me_end) &&~isempty(index_out_me_begin)
                    lastId = index_out_me_end(end);
                    fistId = index_out_me_begin(1);
                                        
                    for nn = fistId:lastId
                        fr_begin = detect_interval(nn,1);
                        fr_end = detect_interval(nn,2);
                        fprintf(fid,'%s %s %s %d %d %s\r\n', vid2txt,'-','-',fr_begin,fr_end,'FP');
                    end
                    end
                    if mm == nb_gt
                        index_out_me_begin = find(detect_interval(:,1)>offset); 
                        if ~isempty(index_out_me_begin)
                        for nn = 1: size(index_out_me_begin,1)                   
                            fr_begin = detect_interval(index_out_me_begin(nn),1);
                            fr_end = detect_interval(index_out_me_begin(nn),2);
                            fprintf(fid,'%s %s %s %d %d %s\r\n', vid2txt,'-','-',fr_begin,fr_end,'FP');            
                        end
                        end
                    end                    
                end
                %------------------tp fp fn in the ME interval----
                
                if ME_info_vid(mm,4)==1 
                    
                    if ME_info_vid(mm,5)==1                    
                        fprintf(fid,'%s %d %d %d %d %s\r\n', vid2txt,ME_info_vid(mm,6),ME_info_vid(mm,7),ME_info_vid(mm,8),ME_info_vid(mm,9),'TP');   
                    elseif  ME_info_vid(mm,5)==0
                        fprintf(fid,'%s %d %d %d %d %s\r\n', vid2txt,ME_info_vid(mm,6),ME_info_vid(mm,7),ME_info_vid(mm,8),ME_info_vid(mm,9),'FP'); 
                        fprintf(fid,'%s %d %d %d %d %s\r\n', vid2txt,ME_info_vid(mm,6),ME_info_vid(mm,7),ME_info_vid(mm,8),ME_info_vid(mm,9),'FN'); 
                    end
                elseif  ME_info_vid(mm,4)==0 &&  ME_info_vid(mm,5)==-1
                    fprintf(fid,'%s %d %d %s %s %s\r\n', vid2txt,ME_info_vid(mm,6),ME_info_vid(mm,7),'-','-','FN'); 
                end
            end
        end      
       
    end    
end
fclose(fid)
   