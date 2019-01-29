%% to count the false positive of lbp method
function fp_video = countFP(detectionRst,maxDist)
% clc;
% maxDist =36;
nbVideo = size(detectionRst,1);
fp_video = zeros(nbVideo,1);
for ii =1:nbVideo
    onset_offset = detectionRst{ii,2};
    detectPeak = detectionRst{ii,1};
    indexTrue = ismember(detectPeak,onset_offset);
    index2delete = indexTrue==1;
    detectPeak(index2delete) = [];
    if size(detectPeak,1)>1
        count1peak =1;
        while count1peak ==1
           count1peak= 0;
           for kk = 1: size(detectPeak,1)-1
               if detectPeak(kk+1)-detectPeak(kk)<maxDist
                   count1peak=1;
                   detectPeak(kk+1)=[];
                   break;
               end
           end
        end       
    end
    if isempty(detectPeak)
        fp_video(ii) = 0;
    else
        fp_video(ii)= size(detectPeak,1);
    end   
    
end