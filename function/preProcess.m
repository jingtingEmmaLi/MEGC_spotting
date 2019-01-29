%% preprocessing
% facial point tracking
% rotation
% cropping and divided into blocks
%%
function blockImageSet = preProcess(landmarks,facePath,X_ratio,Y_ratio,optionBDD)
%% import the landmarks already detected in the first frame of video
% inner eye corners : 23,26
% nasal spine: 17

% LMPath = '../main/allData/CASME1/landmarks/posRoiPerFrame_sub01_EPEP01_5.mat';
%landmarks = importdata(LMPath);
eye1 = landmarks(1,:,23);
eye2 = landmarks(1,:,26);
nasalSpine = landmarks(1,:,17);
line1 = [1,0]-[0,0];
pointSet = double([eye1;eye2;nasalSpine]);
nbFrame = size(landmarks,1);

%% import the images
% facePath = '../EP01_5/';
temp1 = dir([facePath,'*.jpg']);
if strcmp(optionBDD,'CAS1SECB')
    for mm = 1:nbFrame
        if mm == 1
           fileNames = temp1(1).name ; 
        else
            fileNames = char(fileNames,temp1(mm).name);
        end
    end
else
[fileNames,~]= reOrder(temp1);
end
%  videoPlayer = vision.VideoPlayer('Position',[100,100,680,520]);      

%% points trcking 
tracker = vision.PointTracker('MaxBidirectionalError',1);
points = cornerPoints(pointSet);
I = rgb2gray(imread([facePath, fileNames(1,:)]));
initialize(tracker,points.Location,I);
pointsPerFr = zeros(3,2,nbFrame);
for ii = 1:nbFrame
    frame = rgb2gray(imread([facePath, fileNames(ii,:)]));
    [points, ~] = step(tracker,frame);
    pointsPerFr(:,:,ii) = points;
%     out = insertMarker(frame,points(validity, :),'+');
%     step(videoPlayer,out);
   
end
% release(videoPlayer);
%% rotation and blocking 
% distance calculating
line_between_eyes = zeros(nbFrame,2);
distanceHorztl = zeros(nbFrame,1);
distanceVtcl = zeros(nbFrame,1);
for ii = 1:nbFrame
    line_between_eyes(ii,:) = pointsPerFr(2,:,ii)-pointsPerFr(1,:,ii);
    distanceHorztl(ii) = norm(line_between_eyes(ii,:));
    distanceVtcl(ii) = calPt2Seg(pointsPerFr(1,:,ii),pointsPerFr(2,:,ii),pointsPerFr(3,:,ii));
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
blockImageSet = zeros(nbFrame,36,ceil(new_H_block),ceil(new_W_block));
for ii = 1:nbFrame
    frame = rgb2gray(imread([facePath, fileNames(ii,:)]));
    % in-plane rotation
    line2 = line_between_eyes(ii,:);
    angle = acos(dot(line1,line2)/(norm(line1)*norm(line2)));
    newIm = imrotate(frame,angle);
%     figure;imshow(newIm);hold on 

    % blocking -36 blocks depending nasal spine point
    % points important
    X_nasalSpine = pointsPerFr(3,1,ii);
    Y_nasalSpine = pointsPerFr(3,2,ii);
    X_firstPt = X_nasalSpine-3*W_block;
    Y_firstPt = Y_nasalSpine-4*H_block;
    
    % show the grid 
%     X_last = X_nasalSpine+3*W_block;
%     Y_last = Y_nasalSpine+2*H_block;
%     axis_X = X_firstPt:W_block:X_last;
%     axis_Y = Y_firstPt:H_block:Y_last;
%     [X,Y] = meshgrid(axis_X,axis_Y);
%     plot(axis_X,Y','w'); 
%     hold on;
%     plot(X,axis_Y,'w');
%     hold off

    % save the block points
    pointSet = zeros(7,7,2);
    for pp = 1:7
        for qq = 1:7
           pointSet(pp,qq,:)=[X_firstPt+(pp-1)*W_block,Y_firstPt+(qq-1)*H_block]; 
        end
    end
    clear pp qq
    % save bloking region
    kk=1;

    regionBlocks = zeros(36,ceil(new_H_block),ceil(new_W_block));
    [figHeight,figWeidth] = size(newIm);
%     figure;
    for qq = 1:6
        for pp = 1:6
           clear currentBlock;
           currentBlock = zeros(ceil(new_H_block),ceil(new_W_block));
           pt2cut = pointSet(pp,qq,:);
           if qq ==6 && pt2cut(2)+new_H_block > figHeight
               currentBlock = newIm(pt2cut(2):figHeight,pt2cut(1):pt2cut(1)+new_W_block);
               distLack = ceil(pt2cut(2)+new_H_block - figHeight);
               for ll = 1:distLack
               currentBlock(ceil(new_H_block-distLack+ll),:) = newIm(figHeight,pt2cut(1):pt2cut(1)+new_W_block);
               end
           elseif  pp==6 && pt2cut(1)+new_W_block>figWeidth 
               currentBlock = newIm(pt2cut(2):pt2cut(2)+new_H_block,pt2cut(1):figWeidth);
               distLack = ceil(pt2cut(1)+new_W_block - figWeidth);
               for ll = 1:distLack
               currentBlock(ceil(new_W_block-distLack+ll),:) = newIm(pt2cut(2):pt2cut(2)+new_H_block,figWeidth);
               end
           else
           currentBlock = newIm(pt2cut(2):pt2cut(2)+new_H_block,pt2cut(1):pt2cut(1)+new_W_block); 
           end
           regionBlocks(kk,:,:) = currentBlock;
%            subplot(6,6,kk)
%            imshow(currentBlock);
           kk = kk+1;          
        end
    end

      blockImageSet(ii,:,:,:)= regionBlocks;
      
      
    % only show blocking region
%     block_Im = newIm(pointSet(1,1,2):pointSet(7,7,2),pointSet(1,1,1):pointSet(7,7,1)); % XY inverse
%     figure;
%     imshow(block_Im);
%     hold on
%     axis_X_block = axis_X - X_firstPt;
%     axis_Y_block = axis_Y - Y_firstPt;
%     [X_block,Y_block] = meshgrid(axis_X_block,axis_Y_block);
%     plot(axis_X_block,Y_block','w'); 
%     hold on;
%     plot(X_block,axis_Y_block,'w');
  
    
%     if ii==1
%         break;
%     end
end












