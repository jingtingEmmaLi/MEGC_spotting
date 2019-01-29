%% spatial constraint
function [spatialGlobal,spatialPerROI] = spatial2Global(CNperROI,dectPerVideo,nbFrame,nbRegion,pos_nose,nb_nose,pos_mouth,nb_mouth,window)
r_w = 1/9;
CN_moyen = mean(CNperROI);
spatialGlobal = zeros(nbFrame,1);
for jj = 1: nbFrame  
    move_entier = 0;    
    nose_move = 0;
    mouth_move = 0;
    eye_move = 0;
    count_eyeRoi =0;
    rightSide = jj-ceil(window*r_w);
    leftSide = jj + ceil(window*r_w);
    if jj <=ceil(window*r_w)
        rightSide = 1;
    elseif jj> nbFrame - window*r_w
        leftSide = nbFrame;
    end 
    for kk = 1: nbRegion
        %% to delete the subtle mouvements smaller than ME 
%         if CNperROI(kk) > CN_moyen
%             dectPerVideo(kk,jj)=0;
%         end   
       %%
       % count the entier mouvement
         if dectPerVideo(kk,jj)==1
             move_entier =move_entier+1;  
             % first standard : nose region  
             if kk >= pos_nose && kk <=pos_nose+nb_nose-1  
                 %   nose_move = nose_move+1;
                 for aa= pos_nose: pos_nose+nb_nose-1
                     if aa ==kk
                         continue
                     else
                         for bb = rightSide:leftSide
                             if dectPerVideo(aa,bb)==1 
                                 nose_move = nose_move+1;  
                             end
                         end
                     end
                 end
             end
             % eye move
             if kk < pos_nose 
                 for aa= 1: pos_nose-1
                     if aa ==kk
                         continue
                     else 
                         for bb = rightSide:leftSide
                             
                             if dectPerVideo(aa,bb)==1 
                                eye_move = eye_move+1;  
                             end
                         end
                     end
                 end
                 if eye_move>0
                  count_eyeRoi = count_eyeRoi+1;
                 end
             end
             % mouth move
             if kk >= pos_mouth && kk<=pos_mouth+nb_mouth-1
                 mouth_move = mouth_move+1;
             end
         end
    end
    %%
%     if count_eyeRoi>5
%         dectPerVideo(:,rightSide:leftSide)=0;
%     end
    if nose_move >= 1
       dectPerVideo(:,rightSide:leftSide)=0;
    end
    %%
    if mouth_move >= 3 && nb_mouth==8
        dectPerVideo(:,jj)=0;
    end
    %% to delete the mouvement involes two many ROI which will be considered as head mouvement
    if  move_entier>nbRegion/2% move_entier<2 ||
        dectPerVideo(:,jj)=0;
%         dectPerVideo(:,rightSide:leftSide)=0;
    end
end

min_cn = [];
for nn=1:nbFrame
    fr_roi = [];
    for ii = 1: nbRegion   
        if dectPerVideo(ii,nn)==1
         fr_roi = [fr_roi;CNperROI(ii)];
        end           
    end
    if ~isempty(fr_roi)
    min_cn = [min_cn;nn,min(fr_roi)];
    end
end
if ~isempty(min_cn)
nbPeak2count = size(min_cn,1);
mean_minCN =CN_moyen;%1;CN_moyen% mean(min_cn(:,2))
for ff = 1: nbPeak2count
    if min_cn(ff,2)<= mean_minCN
       spatialGlobal(min_cn(ff,1)) =1 ;
    else 
     spatialGlobal(min_cn(ff,1)) =0;  
    end
end
end
%%

spatialPerROI = dectPerVideo;

