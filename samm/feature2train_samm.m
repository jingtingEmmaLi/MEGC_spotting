% this file is to create the traning feature for samm
% output:
% &vector2train
% &label2train
% &info2train need subject info for the test stage- leave one subject out

%%
%configuration;
%%

vector2train = [];
lable2train = []; 
infoTrainFeature = [];
[~,~,raw] = xlsread(inputXlS);


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
        
        if strcmp(bdd,'SAMM')
            MEIndex_vid = find(sammMEinfo(indexSub,2)==str2double(vidIndex));
            onsetInfo = sammMEinfo(indexSub,3);
             
        elseif strcmp(bdd,'CAS(ME)2')
            MEIndex_vid = [];
            nbME = size(indexSub,1);
            for yy = 1:nbME
                
                if strcmp(raw{indexSub(yy),2},vidIndex)
                MEIndex_vid = [MEIndex_vid;yy];
                end
            end
            onsetInfo = casMEinfo(indexSub,1);           
        end
        distanceNormPath_vid=[distanceNormPath,sub_vid_path];
        if ~isempty(MEIndex_vid)
            indexWindowPath_vid = [indexWindowPath,subName,'/'];
            windowIndex = importdata([indexWindowPath_vid,vidIndex,'_indexWindow.mat']);
            charNames = importdata([indexWindowPath_vid,vidIndex,'_indexChar.mat']);
            clipsInfo = importdata([indexWindowPath_vid,vidIndex,'_clipsInfo.mat']);
            for mm = 1:size(MEIndex_vid,1)
                onset_vid = onsetInfo(MEIndex_vid(mm));
                nbseq = indexSub(MEIndex_vid(mm));
                vidIndexBeforeOnset = find(windowIndex<onset_vid);
                clipSelected =  vidIndexBeforeOnset(end);
                clip_begin = windowIndex(clipSelected,1) ;
                onset= onset_vid-clip_begin+2;
                indexChar = charNames(clipSelected,:);
                nbFrame = clipsInfo(clipSelected,1);
                vecto2testPath_vid = [vecto2testPath,sub_vid_path];
                distance_clips = importdata([vecto2testPath_vid,indexChar,'_vec2test.mat']);
                current_CN = distance_clips(:,1);
                CNperROI_temp = reshape(current_CN,nbFrame,nbRegion);    
                CNperROI(:) = CNperROI_temp(1,:);
                mean_cn = mean(CNperROI);  
                [au_info,au_side] = xlsAUinfo_update(inputXlS,nbseq,colomnXls);
                if strcmp(roiType, 'patial')
                    pos_nose = 7;
                    pose_mouth = 9;
                    [nb2train,index2train] = selectROI2train(pos_nose,pose_mouth, nbROI,nbRegion,au_info,au_side); 
                elseif strcmp(roiType, 'entier')
                    pos_nose = 11;
                    pose_mouth = 15;
                    [nb2train,index2train] = selectROI2train(pos_nose,pose_mouth, nbROI,nbRegion,au_info,au_side);  
                end
                
                index2train
                nb2train
                % get the max onset distance value
                max_dist = zeros(size(index2train,2),1);
                toEmpty = [];
                for kk = 1: size(index2train,2)
                    RoiLm = nb2train(kk);
                    data2treat = importdata([distanceNormPath_vid,indexChar,'_',num2str(RoiLm),'_dst_norm.mat']);
                    dataEnd = size(data2treat,2);
                    maxEnd = ceil(nbIntervalPt/2)+1;
                    distance2treat = data2treat(onset-1,2:maxEnd);
                    max_dist(kk)= max(distance2treat);
                    if max_dist(kk)<seuil_indensity 
                        toEmpty = [toEmpty,kk];
                    else
                        if CNperROI(kk)>mean_cn
                            toEmpty = [toEmpty,kk];
                        else
                            pente1 = polyfit(1:maxEnd-1,distance2treat,1);
                            if size(1:maxEnd,2)~=size(maxEnd:dataEnd,2)
                            pente2 = polyfit(1:maxEnd,data2treat(onset-1,maxEnd-1:end),1);
                            else 
                                pente2 = polyfit(1:maxEnd,data2treat(onset-1,maxEnd:end),1);
                            end
                            zeroDist = find(data2treat(onset-1,maxEnd:end)==0);
                        
                            if pente1(1)>0 && pente2(1)<=0 && isempty(zeroDist)
                                continue;
                            else
                                toEmpty = [toEmpty,kk];
                            end
                        end
                    end
                end
                % select the training feature with two maximum value
                roi2train_temp = nb2train;     
                roi2train_temp(toEmpty) = []   ;   
                max_dist(toEmpty) = [];
                kk=1;
                roi2train=[];dist=[];index_final = [];
                while  ~isempty(max_dist)
                    [dist(kk),index_final(kk)] = max(max_dist);
                    roi2train(kk)=roi2train_temp(index_final(kk)) ;
                    max_dist(index_final(kk)) = []; 
                    roi2train_temp(index_final(kk)) = []; 
                    kk = kk+1;
                    if kk>2
                        break;
                    end
                end
                roi2train
                
                
                nbroi2train = size(roi2train,2);
                
                
                
                % generate feature 2 train
                if ~isempty(roi2train)
                    for nn = 1:nbroi2train  
                        % import data from different ROI 
                        RoiLm = roi2train(nn);
                        %disp(['ROI: ',num2str(RoiLm)]);
                        data2treat = importdata([distanceNormPath_vid,indexChar,'_',num2str(RoiLm),'_dst_norm.mat']);
                        nbFrame = size(data2treat,1);
                        distance2train = data2treat(:,1:end); 
                        lables_in1clip = zeros(nbFrame,1);  
                        if onset<=label2one
                            lables_in1clip(1:onset)=1;
                        else
                            for pp = 1:label2one
                                lables_in1clip(onset-label2one-1+pp)=1;
                            end
                        end
            
             % reduce the zero element
             loc2delete = [];
             m = 1;
             while  m*sampleRate2train<=nbFrame
                 if m*8<=onset-label2one-1 
                     order = ((m-1)*sampleRate2train);
                     location = zeros(1,sampleRate2train-1);
                     for qq = 1:sampleRate2train-1
                         location(qq) = order+qq;
                     end
                     loc2delete  = [loc2delete,location];
                 elseif m*sampleRate2train>onset && (m+1)*sampleRate2train<nbFrame
                     order = m*sampleRate2train;
                     location = zeros(1,sampleRate2train-1);
                     for qq = 1:sampleRate2train-1
                         location(qq) = order+qq; 
                     end
                     loc2delete  = [loc2delete,location];
                 end
                 m = m+1;
             end
             % form the training feature
             locFr = 1:nbFrame;
             locFr(loc2delete) = [];
             frameLoc{nbseq,1}=locFr;
             distance2train(loc2delete,:) = [];
             lables_in1clip(loc2delete,:) = [];
             sizeNewFeature = size(distance2train,1);
             vector2train = [vector2train; distance2train];
             lable2train = [lable2train;lables_in1clip];
         end
     else 
         sizeNewFeature = 0;
     end
         nbVec=size(vector2train,1);
     sizelable = size(lable2train,1);
     if nbVec~= sizelable
         nbseq
         break;
     end
     infoTrainFeature = [infoTrainFeature; [nbseq ,nbFrame,sizeNewFeature*nbroi2train ,nbVec ]];        
                
                
                
            end
            
            
        end
        
           
    end
        
end
   
save([vec2trainPath,'vector2train.mat'],'vector2train');
save([vec2trainPath,'lable2train.mat'],'lable2train');
save([vec2trainPath,'trainfeatureInfo.mat'],'infoTrainFeature');
 