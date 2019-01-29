%% filter the result per roi by CN and distance_max
%% temporal selection per roi
%%
function [temporalGlobal, temporalPerROI]= selectionPerROI(dist_video,dectPerVideo,nbFrame,nbRegion,window,seuil_indensity,CNperROI,r_w_ROI,cn_ratio)
r_w = r_w_ROI;
temporalGlobal = zeros(nbFrame,1);
% only consider the ROI lower than cn_moyen
region_index = 1:nbRegion ;
toEmpty = [];
for ii = 1:nbRegion  
    if CNperROI(ii)> mean(CNperROI) %(max(CNperROI)-min(CNperROI))*0.4+min(CNperROI)%mean(CNperROI) (max(CNperROI)-min(CNperROI))*0.4+min(CNperROI)%;% mean(CNperROI)%mean(CNperROI)*cn_ratio

       dectPerVideo(ii,:)=0;
       toEmpty =[toEmpty ,ii];
    end
end
region_index(toEmpty)=[];
nbSelectedROI = size(region_index,2);
for ii = 1:nbSelectedROI
    %%  distance value threshold
    crtRoi = region_index(ii);
    dist_roi = dist_video((crtRoi-1)*nbFrame+1:crtRoi*nbFrame,:);
    for jj=1:nbFrame
        if dectPerVideo(crtRoi,jj)==1
            distMax = max(dist_roi(jj,:));
            if distMax<seuil_indensity
                dectPerVideo(crtRoi,jj)=0;           
            end                       
        end
         
    end
 %% first step: count the non-zeros peak in search window   
   
    jj=1;
    countPeakInROI = [];
    while jj <=nbFrame  
        if dectPerVideo(ii,jj)==0
            jj=jj+1;
        elseif dectPerVideo(ii,jj)==1           
            nb_frameTrueContinous = 0;
            posframe = [];
            if jj<nbFrame-ceil(window*r_w)
                for qq = jj:jj+ceil(window*r_w)
                    if dectPerVideo(ii,qq)==1
                        nb_frameTrueContinous = nb_frameTrueContinous+1;
                        posframe = [posframe,qq];
                    end
                end  
                countPeakInROI = [countPeakInROI;jj,nb_frameTrueContinous] ;
                jj = jj+ceil(window*r_w)+1;
            elseif jj>=nbFrame-ceil(window*r_w)
                for qq = jj:nbFrame
                    if dectPerVideo(ii,qq)==1
                        nb_frameTrueContinous = nb_frameTrueContinous+1;
                        posframe = [posframe,qq];
                    end
                end
                countPeakInROI = [countPeakInROI;jj,nb_frameTrueContinous] ;
                jj = nbFrame;  
            end
            
        end
    end
    % processing per ROI : conserve the interval which has the most peaks
% countPeakInROI

%     if ~isempty(countPeakInROI)
%         indexMax = find(countPeakInROI(:,2)>2 ) ;
%         if ~isempty(indexMax) && size(countPeakInROI,1)>1          
%             inde2zero = countPeakInROI(:,1);            
%                 inde2zero(indexMax) = [];
%                 nbPeak = size(inde2zero,1);             
%                 for pp = 1:nbPeak
%                     if inde2zero(pp)+window*r_w<nbFrame
%                         dectPerVideo(ii,inde2zero(pp):inde2zero(pp)+window*r_w) =0;
%                     else
%                         dectPerVideo(ii,inde2zero(pp):nbFrame) =0;
%                     end
%                 end
%         end
%     end
   if ~isempty(countPeakInROI)
        indexMax = find(countPeakInROI(:,2)>2 ) ;
        inde2zero = countPeakInROI(:,1);
        if ~isempty(indexMax) && size(countPeakInROI,1)>1 
                inde2zero(indexMax) = [];
                nbPeak = size(inde2zero,1);  
                %to choose 
        for pp = 1:nbPeak
                    if inde2zero(pp)+ceil(window*r_w)<nbFrame
                        dectPerVideo(ii,inde2zero(pp):inde2zero(pp)+ceil(window*r_w)) =0;
                    else
                        dectPerVideo(ii,inde2zero(pp):nbFrame) =0;
                    end
                end
        end
        
    end
end
temporalPerROI = dectPerVideo;
for jj = 1:nbFrame
    for pp = 1:nbRegion
        if dectPerVideo(pp,jj)==1
            temporalGlobal(jj) = 1 ;
            break;
        end
    end
end

end
    
    