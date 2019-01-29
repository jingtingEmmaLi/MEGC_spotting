%% preprocessing
% facial point tracking
% rotation
% cropping and divided into blocks
%%
index_iijj=[19,4;22,4];
warning('off','all')
for mm = 1:size(index_iijj,1)
    ii =index_iijj(mm,1);

    subName = subFiles(ii).name;
    vidFiles = dir([outputLMpath,subName,'/']);
    nbVid = length(vidFiles);
    jj= index_iijj(mm,2);
        
        indexWindow=[];
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
            posRoiTxt = textread([LMpath_vid,LMs(kk).name]); 
            if posRoiTxt(1,1) <=0 && posRoiTxt(2,1) <=0
                posRoiTxt = textread([LMpath_vid,LMs(kk+1).name]);
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
        avg_dstHztl = mean(distanceHorztl);
        avg_dstVtcl = mean(distanceVtcl);
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
        [nbFrame,36,ceil(new_H_block),ceil(new_W_block)]
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
                if qq ==6 && pt2cut(2)+new_H_block > figHeight
                    
                    currentBlock(1:(figHeight-pt2cut(2)+1),:) = newIm(pt2cut(2):figHeight,pt2cut(1):pt2cut(1)+new_W_block);
                    distLack = ceil(pt2cut(2)+new_H_block - figHeight);
                    for ll = 1:distLack
                        currentBlock(ceil(new_H_block-distLack+ll),:) = newIm(figHeight,pt2cut(1):pt2cut(1)+new_W_block);
                    end
                elseif  pp==6 && pt2cut(1)+new_W_block>figWeidth 
                    currentBlock(:,figWeidth-pt2cut(1)+1) = newIm(pt2cut(2):pt2cut(2)+new_H_block,pt2cut(1):figWeidth);
                    distLack = ceil(pt2cut(1)+new_W_block - figWeidth);
                    for ll = 1:distLack
                        currentBlock(:,ceil(new_W_block-distLack+ll)) = newIm(pt2cut(2):pt2cut(2)+new_H_block,figWeidth);
                    end
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












