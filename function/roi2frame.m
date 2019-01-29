%% spatial constraint posNose2zero,posMouth2zero,posEye2zero
function [finalGlobal,finalPerROI] = roi2frame(dectPerVideo,temporalPerROI,nbFrame,nbRegion,pos_nose,nb_nose,pos_mouth,nb_mouth,window)
r_w = 1/9;

finalGlobal = zeros(nbFrame,1);

for jj = 1: nbFrame  
    move_entier = 0;    
    nose_move = 0;
    mouth_move = 0;
    eye_move = 0;
    
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
             %move_entier = countMERegion(1,nbRegion,rightSide,leftSide,dectPerVideo,kk)
            
             move_entier =move_entier+1;  
             % first standard : nose region  
             if kk >= pos_nose && kk <=pos_nose+nb_nose-1  
                   nose_move = nose_move+1;
                % nose_move = countMERegion(pos_nose, pos_nose+nb_nose-1,rightSide,leftSide,dectPerVideo,kk);
                 
             % eye move
             elseif kk < pos_nose
                 eye_move = eye_move+1;
                 %eye_move= countMERegion(1, pos_nose-1,rightSide,leftSide,dectPerVideo,kk);                            
             % mouth move
             elseif kk >= pos_mouth && kk<=pos_mouth+nb_mouth-1
                 mouth_move = mouth_move+1;
             end
         end
    end
    %%
    if eye_move>5
%         temporalPerROI(:,rightSide:leftSide)=0;
        temporalPerROI(:,jj)=0;
     
    end
    if nose_move >=2
%        temporalPerROI(:,rightSide:leftSide)=0;
        temporalPerROI(:,jj)=0;

    end
    %%
    if mouth_move >= 3 && nb_mouth==8
        temporalPerROI(:,jj)=0;        
    end
    %% to delete the mouvement involes two many ROI which will be considered as head mouvement
%     if  move_entier>nbRegion/2% move_entier<2 ||
%         temporalPerROI(:,rightSide:leftSide)=0;
%         
%         dectPerVideo(:,rightSide:leftSide)=0;
%     end
end
finalPerROI = temporalPerROI;
%%


for jj = 1:nbFrame
    for pp = 1:nbRegion
        if temporalPerROI(pp,jj)==1
            finalGlobal(jj) = 1 ;
            break;
        end
    end
end

