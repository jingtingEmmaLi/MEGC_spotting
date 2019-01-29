%% temporal selection per roi
%%
function [temporalGlobal, temporalPerROI]= temporalFusion(CNperROI,dectPerVideo,nbFrame,nbRegion,window)
r_w = 1/3;
temporalGlobal = zeros(nbFrame,1);
%% ROI number selection
countPeakInDiffROI = [];
pos_fr = [0,0];
 %% first step: count the non-zeros peak in search window   
for ii = 1:nbRegion     
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
    if ~isempty(countPeakInROI)
        indexMax = find(countPeakInROI(:,2)>2 ) ;
        if ~isempty(indexMax) && size(countPeakInROI,1)>1          
            inde2zero = countPeakInROI(:,1);            
                inde2zero(indexMax) = [];
                nbPeak = size(inde2zero,1);             
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

%% temporal lissage

temporalPerROI = dectPerVideo;
mean_cn = [];
for nn=1:nbFrame
    fr_roi = [];
    for ii = 1: nbRegion   
        if dectPerVideo(ii,nn)==1
%             if ii<pos_nose
%                 cn_moyen = mean(CNperROI(1:pos_nose-1));
%             elseif ii >=pos_mouth
%                 cn_moyen = mean(CNperROI(pos_mouth:end));
%             else 
%                 cn_moyen = mean(CNperROI(pos_nose:pos_mouth-1));
%             end
            cn_moyen = CNperROI(ii);
            fr_roi = [fr_roi;cn_moyen];
        end           
    end
    if ~isempty(fr_roi)
    mean_cn = [mean_cn;nn,min(fr_roi)];
    end
end
% mean_cn
if ~isempty(mean_cn)
nbPeak2count = size(mean_cn,1);
maxCN = mean(mean_cn(:,2));%1;
for ff = 1: nbPeak2count
    if mean_cn(ff,2)<= maxCN
       temporalGlobal(mean_cn(ff,1)) =1 ;
    else 
     temporalGlobal(mean_cn(ff,1)) =0;  
    end
end
end

end
    
    