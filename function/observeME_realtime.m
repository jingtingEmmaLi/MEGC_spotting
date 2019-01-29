%% function to observe the result on real time
%
%%
% function output_frame = observeME_realtime(bbdinfo,nb)

output_frame = figure;
 k=9;
bbdinfo = '../data/CASME_SectionA_modified.xls';
nb = 7;
[sub, filename, onset, apex, offset] = xlsImport(bbdinfo,nb);
if strcmp(offset,'\')
    offset = 2*apex(1)-onset;
end
[au_info,au_side] = xlsAUinfo(bbdinfo,nb);
% nbAU = size(au_info,2)
MEinput = ['h:/lab/pcaMEs/CASME 1/CASME_A/Section A/',sub,'/',filename,'/'];
temp1 = dir([MEinput,'*.jpg']);
landsmarks = importdata(['../allData/CASME1/landmarks/posRoiPerFrame_',sub,'_',filename,'.mat']);
firstPtSet(:,:) = landsmarks(1,:,:);
clear landsmarks;
[fileNames,nbFig]= reOrder(temp1);
detetionPerROI = importdata('../allData/CASME1/data2ML/allEmotion/detectionMEperROI.mat');
detectionperFrame = importdata('../allData/CASME1/data2ML/allEmotion/detectionME.mat');
videoFrame = importdata('../allData/CASME1/data2ML/allEmotion/videoFrame.mat');
detectCurrtVideo = detetionPerROI(videoFrame(nb,1):videoFrame(nb,2),:);
detectperFrame = detectionperFrame(videoFrame(nb,1):videoFrame(nb,2),:);
nbROI = importdata('nbROI.mat');
nbRegion = size(nbROI,2);
clear detetionPerROI videoFrame

LBPresult = importdata('detectionResult_LBP_96video.mat');
LBPcurrent = LBPresult{nb,:};

writerObj=VideoWriter('test.avi');  %// ?????????????  
open(writerObj); 
figure;
for ii=1:91%nbFig
    
    frames = imread([MEinput,fileNames(ii,:)]);
    imshow(frames);
    hold on
    
    %% the ground truth
    if ii>=onset-k && ii<=offset+k
        if find(au_info<=4) 
            c = firstPtSet(1,5) - firstPtSet(1,1) ;   %width
            d = (firstPtSet(2,20) - firstPtSet(2,1)); %height   
            if strcmp(au_side,'N')
                % rignt eyes   
                a = firstPtSet(1,1);                  
                b = firstPtSet(2,1)-(firstPtSet(2,20) - firstPtSet(2,1))/1.5;            
                rectangle('position',[a b c d],'EdgeColor','r');
                clear a b
                % left eyes             
                a = firstPtSet(1,6);
                b = firstPtSet(2,10)-(firstPtSet(2,29) - firstPtSet(2,10))/1.5;
                rectangle('position',[a b c d],'EdgeColor','r');
                clear a b c d 
            elseif strcmp(au_side,'R')
                a = firstPtSet(1,1);                   
                b = firstPtSet(2,1)-(firstPtSet(2,20) - firstPtSet(2,1))/1.5;
            
                rectangle('position',[a b c d],'EdgeColor','r');
                clear a b c d 
            elseif strcmp(au_side,'L')
                a = firstPtSet(1,6);
                b = firstPtSet(2,10)-(firstPtSet(2,29) - firstPtSet(2,10))/1.5;
                rectangle('position',[a b c d],'EdgeColor','r');
                clear a b c d 
            end
        elseif find(au_info>=10) 
            c = (firstPtSet(1,38) - firstPtSet(1,32))*1.5 ;   %width
            d = (firstPtSet(2,41) - firstPtSet(2,35))*1.5; %height   
            if strcmp(au_side,'N')
                % entier mouth   
                a = firstPtSet(1,32)-c/15;                  
                b = firstPtSet(2,34)-d/15;            
                rectangle('position',[a b c d],'EdgeColor','r');
                              
                clear a b c d 
            elseif strcmp(au_side,'R')
                a = firstPtSet(1,32)-c/15;                         
                b = firstPtSet(2,34)-d/15;      
                c = c/2;
                rectangle('position',[a b c d],'EdgeColor','r');
                clear a b c d 
            elseif strcmp(au_side,'L')
                a = firstPtSet(1,35);
                b = firstPtSet(2,36)-d/15;  
                c = c/2;
                rectangle('position',[a b c d],'EdgeColor','r');
                clear a b c d 
            end
        end
    end
   %% import the our method result
   for jj = 1:nbRegion
       if detectCurrtVideo(ii,jj)==1 && detectperFrame(ii)==1         
           plot(firstPtSet(1,nbROI(jj)),firstPtSet(2,nbROI(jj)),'b*')
           if jj<5
               c =( firstPtSet(1,5) - firstPtSet(1,1))*0.9 ;   %width
               d = (firstPtSet(2,20) - firstPtSet(2,1))*0.9; %height 
               % rignt eyes   
               a = firstPtSet(1,1); 
               b = firstPtSet(2,1)-(firstPtSet(2,20) - firstPtSet(2,1))/1.5;
               rectangle('position',[a b c d],'EdgeColor','b');
               clear a b
               % left eyes             
               a = firstPtSet(1,6);
               b = firstPtSet(2,10)-(firstPtSet(2,29) - firstPtSet(2,10))/1.5;
               rectangle('position',[a b c d],'EdgeColor','b');
               clear a b c d 
           elseif jj>8
               c = (firstPtSet(1,38) - firstPtSet(1,32))*1.4 ;   %width
                d = (firstPtSet(2,41) - firstPtSet(2,35))*1.4; %height   
            
                % entier mouth   
                a = firstPtSet(1,32)-c/15;                  
                b = firstPtSet(2,34)-d/15;            
                rectangle('position',[a b c d],'EdgeColor','b');
           end
           title(['current frame: ', num2str(ii)]);
           pause(1);
       else 
           title('');
           
       end
   end
   %% import the LBP detection result
   if find(LBPcurrent==ii)
       plot(50,50,'ys','MarkerEdgeColor','k',...
                       'MarkerFaceColor','g',...
                       'MarkerSize',10);
       xlabel(['LBP detect ME at: ', num2str(ii)]);
       pause(1);
   else
        xlabel('') ;          
   end
      
drawnow;
frame = getframe;            %// ??????????  
writeVideo(writerObj,frame);
end
close(writerObj); %// ????????  
% end


