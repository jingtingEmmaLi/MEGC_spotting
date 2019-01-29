%% determine the ROI size depending on the deteted landmarks 
%%
function sizeROI = roiSize_longVid(subFiles,nbSub,outputLMpath,length_w,overlap) 

distTotal = [];
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
        
        LMpath_vid = [outputLMpath,sub_vid_path];
        
        
        LMs = dir([LMpath_vid,'*.txt']);
        nbFrame = length(LMs);
        kk = 1;
        while kk  <= nbFrame
            [LMpath_vid,LMs(kk).name]
            posRoiTxt = textread([LMpath_vid,LMs(kk).name]);% all depending on the first frame
            if posRoiTxt(1,1) <=0
                posRoiTxt = textread([LMpath_vid,LMs(kk+1).name]);
            end
            lengthTxt = size(posRoiTxt,1);
            posRoi = zeros(lengthTxt/2,2);
            for pp = 1:lengthTxt/2 
                posRoi(pp,1) = posRoiTxt(2*pp-1) ;
                posRoi(pp,2) = posRoiTxt(2*pp) ;
            end
            %dist = posRoi(48,1)-posRoi(45,1);
            dist = posRoi(24,1)-posRoi(18,1);
            distTotal = [distTotal, dist];
            kk = kk+length_w-overlap;
            ii 
            jj
            kk
        end 
      
    end
     
end
distMoyen = mean(distTotal);
lengthInterval = (distMoyen)/4; % 4 segments between landmark 1 and 5, 5 is to detemine the size of 
sizeROI = fix(lengthInterval/5)*5;