%% filter the result per roi by CN and distance_max
%% temporal selection per roi
%%
function [temporalGlobal, temporalPerROI]= temporalFiltrage(dist_video,dectPerVideo,nbFrame,nbRegion,window,seuil_indensity)
r_w = 1/3;
temporalGlobal = zeros(nbFrame,1);
for ii = 1:nbRegion  
    %%  distance value threshold
    dist_roi = dist_video((ii-1)*nbFrame+1:ii*nbFrame,:);
    jj =1;
    while jj<=nbFrame
        if dectPerVideo(ii,jj)==0
            jj=jj+1;
        else
            kk = 0;            
            while dectPerVideo(ii,jj+kk)==1
                kk=kk+1;
                if jj+kk>=nbFrame
                    break;
                end
            end
            distMax = max(max(dist_roi(jj:jj+kk-1,:),[],2));
            if distMax<seuil_indensity
                dectPerVideo(ii,jj:jj+kk-1)=0;
            end
            jj = jj+kk;             
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
            if jj<nbFrame-window*r_w
                for qq = jj:jj+window*r_w
                    if dectPerVideo(ii,qq)==1
                        nb_frameTrueContinous = nb_frameTrueContinous+1;
                        posframe = [posframe,qq];
                    end
                end  
                countPeakInROI = [countPeakInROI;jj,nb_frameTrueContinous] ;
                jj = jj+window*r_w+1;
            elseif jj>=nbFrame-window*r_w
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
                    if inde2zero(pp)+window*r_w<nbFrame
                        dectPerVideo(ii,inde2zero(pp):inde2zero(pp)+window*r_w) =0;
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
    
    