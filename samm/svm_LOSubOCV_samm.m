%%
% svm - leave one subject out
%

%%
%configuration;
%
vec2train =importdata([vec2trainPath,'vector2train',trainVecComposition,'.mat']);
label2train = importdata([vec2trainPath,'lable2train',trainVecComposition,'.mat']);
infoTrainFeature = importdata([vec2trainPath,'trainfeatureInfo',trainVecComposition,'.mat']);

[~,~,raw] = xlsread(inputXlS);

%%
% figure;
% k=150
% for ii =1:10
%     
%     subplot(5,2,ii);
%     plot(vec2train(ii+k,2:end));    
% end
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
    vec2train_saufSub = vec2train;
    label2train_saufSub = label2train;
    % train model per subject 
    if ~isempty(indexSub)
    if indexSub(1)==1
        firstPos = 1;
    else
        firstPos = infoTrainFeature(indexSub(1)-1,4)+1;
    end 
    lastPos = infoTrainFeature(indexSub(end),4);
    
    if firstPos~=lastPos    
        vec2train_saufSub(firstPos:lastPos,:) = [];
        label2train_saufSub(firstPos:lastPos,:) = [];
    end
    
    end
    tic;
    model = libsvmtrain(label2train_saufSub, vec2train_saufSub, '-t 0 -g 0.5 -c 5 -w0 1 -w1 2.5 ' );
    toc;
    
    
    % test for each clip in each videos
    
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
        clipsInfo = importdata([indexWindowPath_vid,vidIndex,'_clipsInfo.mat']);
        
        nbClips = size(windowIndex,1);
        
        vecto2testPath_vid = [vecto2testPath,sub_vid_path];
        predictLabelPath_vid = [predictLabelPath,sub_vid_path];
        createFold(predictLabelPath_vid);
        
        for kk = 1:nbClips            
            indexChar = charNames(kk,:);            
               
            clip2test = importdata([vecto2testPath_vid,indexChar,'_vec2test.mat']);
            label2test_clip = zeros(size(clip2test,1),1);
            tic;
            [predicted_labelperClip, ~, ~] = libsvmpredict(label2test_clip, clip2test, model);
            toc;
            save([predictLabelPath_vid,indexChar,trainVecComposition,'_predictLabel.mat'],'predicted_labelperClip');
            
        end
         
        ii
        jj
    end
   
 end
 

