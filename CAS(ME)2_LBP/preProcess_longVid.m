%% preprocessing
% facial point tracking
% rotation
% cropping and divided into blocks
%%
function preProcess_longVid(subFiles,nbSub,outputLMpath,databasePath,X_ratio,Y_ratio,BlockupperPath)
warning('off','all')
for ii =22:nbSub
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
        
        vidIndex = vidFiles(jj).name;
        sub_vid_path = [subName,'/',vidIndex,'/'];
        facePath = [databasePath,sub_vid_path];
        LMpath_vid = [outputLMpath,sub_vid_path];
        blockVidPath =[BlockupperPath,subName,'/'] ;
        createFold(blockVidPath);
        temp1 = dir([facePath,'*.jpg']);
        LMs = dir([LMpath_vid,'*.txt']);
        nbFrame = length(LMs); 
        nose_point = zeros(nbFrame,2);
        line_between_eyes = zeros(nbFrame,2);
        distanceHorztl = zeros(nbFrame,1); 
        distanceVtcl = zeros(nbFrame,1); 
        line1 = [1,0]-[0,0];
        for kk = 1:nbFrame 
            img2treat = imread([facePath, temp1(kk).name]);
            
            if size(size(img2treat),2) ==3 
                frame = rgb2gray(img2treat);
            else
                frame = img2treat;
            end
            [edge1,edge2] = size(frame);
            edgeLM = max(edge1,edge2);
            
            posRoiTxt = lmTxT2Array([LMpath_vid,LMs(kk).name]);
            xx= 1;
            while ((posRoiTxt(1,1) <=0 && posRoiTxt(2,1) <=0) || posRoiTxt(96)==0 || posRoiTxt(90) ==0 ||  mean(posRoiTxt)>edgeLM) && kk+xx<=nbFrame 
                posRoiTxt = [];
                posRoiTxt = lmTxT2Array([LMpath_vid,LMs(kk+xx).name]);
                xx=xx+1;
            end            
            lengthTxt = size(posRoiTxt,1);
            pointsPerFr = zeros(lengthTxt/2,2);
            for pp = 1:lengthTxt/2 
                pointsPerFr(pp,1) = posRoiTxt(2*pp-1) ;
                pointsPerFr(pp,2) = posRoiTxt(2*pp) ;
            end  
            line_between_eyes(kk,:) = pointsPerFr(48,:)-pointsPerFr(45,:);            
            distanceHorztl(kk) = norm(line_between_eyes(kk,:));           
            distanceVtcl(kk) = calPt2Seg(pointsPerFr(45,:),pointsPerFr(48,:),pointsPerFr(61,:));
            nose_point(kk,:) = pointsPerFr(61,:);            
        end
        % distance moyen
        
        avg_dstHztl = nanmean(distanceHorztl);
        avg_dstVtcl = nanmean(distanceVtcl);
        % ratio adaptive
        ratio_hztl = 2;
        ratio_temp = avg_dstVtcl/avg_dstHztl;
        ratio_vtcl = ratio_temp+1;
        % distance for sommet of blocks
        W_block = avg_dstHztl/ratio_hztl;
        H_block = avg_dstVtcl/ratio_vtcl;
        %% block real size with overlap ratio
        new_H_block = H_block*(1+Y_ratio);
        new_W_block = W_block*(1+X_ratio);
        blockImageSet = zeros(nbFrame,36,ceil(new_H_block),ceil(new_W_block));
        for kk = 1:nbFrame
           
            img2treat = imread([facePath, temp1(kk).name]);
            
            if size(size(img2treat),2) ==3 
                frame = rgb2gray(img2treat);
            else
                frame = img2treat;
            end
            % in-plane rotation
            line2 = line_between_eyes(kk,:);
            if line2(1) ==0 && line2(2) ==0
                line2 = [1,0]-[0,0];
            end
            angle = acos(dot(line1,line2)/(norm(line1)*norm(line2)));
            newIm = imrotate(frame,angle);
            %     figure;imshow(newIm);hold on 

    % blocking -36 blocks depending nasal spine point
    % points important
            X_nasalSpine = nose_point(kk,1);
            Y_nasalSpine = nose_point(kk,2);
            X_firstPt = X_nasalSpine-3*W_block;
            if X_firstPt<=1
                X_firstPt=1;
            end
            Y_firstPt = Y_nasalSpine-4*H_block;
            if Y_firstPt<=1
                Y_firstPt=1;
            end
  

    % save the block points
            pointSet = zeros(7,7,2);
            for pp = 1:7
                for qq = 1:7
                    pointSet(pp,qq,:)=[X_firstPt+(pp-1)*W_block,Y_firstPt+(qq-1)*H_block]; 
                end
            end
            clear pp qq
    % save bloking region
            aa=1;

            regionBlocks = zeros(36,ceil(new_H_block),ceil(new_W_block));
            [figHeight,figWeidth] = size(newIm);
            %     figure;
            for qq = 1:6
                for pp = 1:6
                clear currentBlock;
                currentBlock = zeros(ceil(new_H_block),ceil(new_W_block));
                pt2cut = pointSet(pp,qq,:);
                if  pt2cut(2)+new_H_block > figHeight && pt2cut(1)+new_W_block < figWeidth %%&&qq ==6 
                    currentBlock(1:floor(figHeight-pt2cut(2))+1,:) = newIm(pt2cut(2):figHeight,pt2cut(1):pt2cut(1)+new_W_block);
                    distLack = ceil(pt2cut(2)+new_H_block - figHeight);
                    for ll = 1:distLack
                        currentBlock(ceil(new_H_block-distLack+ll),:) = newIm(figHeight,pt2cut(1):pt2cut(1)+new_W_block);
                    end
                elseif   pt2cut(1)+new_W_block>figWeidth  && pt2cut(2)+new_H_block<figHeight %% && pp==6 
                    currentBlock(:,1:floor(figWeidth-pt2cut(1)+1)) = newIm(pt2cut(2):pt2cut(2)+new_H_block,pt2cut(1):figWeidth);
                    distLack = ceil(pt2cut(1)+new_W_block - figWeidth);
                    for ll = 1:distLack
                        currentBlock(:,ceil(new_W_block-distLack+ll)) = newIm(pt2cut(2):pt2cut(2)+new_H_block,figWeidth);
                    end
                elseif pt2cut(1)+new_W_block>figWeidth && pt2cut(2)+new_H_block > figHeight 
                    currentBlock(1:floor(figHeight-pt2cut(2))+1,1:floor(figWeidth-pt2cut(1)+1)) = newIm(pt2cut(2):figHeight,pt2cut(1):figWeidth);
                    
                    distLack_H = ceil(pt2cut(2)+new_H_block - figHeight);
                    distLack_W = ceil(pt2cut(1)+new_W_block - figWeidth);
                    
                    for ll = 1:distLack_H
                        currentBlock(ceil(new_H_block-distLack_H+ll),1:figWeidth-pt2cut(1)+1) = newIm(figHeight,pt2cut(1):figWeidth);
                    end 
                    
                    for ll = 1:distLack_W
                        currentBlock(1:figHeight-pt2cut(2)+1,ceil(new_W_block-distLack_W+ll)) = newIm(pt2cut(2):figHeight,figWeidth);
                    end
                    currentBlock(new_H_block-distLack_H+1:new_H_block,new_W_block-distLack_W+1:new_W_block) =newIm(figHeight,figWeidth);
                else 
                    
                   currentBlock = newIm(pt2cut(2):pt2cut(2)+new_H_block,pt2cut(1):pt2cut(1)+new_W_block); 
                end
                regionBlocks(aa,:,:) = currentBlock;
%            subplot(6,6,kk)
%            imshow(currentBlock);
                aa =  aa+1;          
                end
            end

      blockImageSet(kk,:,:,:)= regionBlocks;
      clear regionBlocks;
        end
      save([blockVidPath,vidIndex,'_blockVid.mat'],'blockImageSet', '-v7.3')
      clear blockImageSet;
      ii
      jj
    end
end












