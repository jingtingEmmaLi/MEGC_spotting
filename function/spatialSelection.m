%% spatial constraint
function [spatialGlobal,spatialPerROI] = spatialSelection(CNperROI,dectPerVideo,nbFrame,nbRegion,pos_nose,nb_nose,pos_mouth,nb_mouth,window)
r_w = 1/9;
CN_moyen = mean(CNperROI);
spatialGlobal = zeros(nbFrame,1);
for jj = 1: nbFrame  
    move_entier = 0;    
    nose_move = 0;
    mouth_move = 0;
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
         end

%         first standard : nose region
                     
        if kk >= pos_nose && kk <=pos_nose+nb_nose-1
             if dectPerVideo(kk,jj)==1 
%                  nose_move = nose_move+1;
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
         end         
         % mouth move         
         if kk >= pos_mouth && kk<=pos_mouth+nb_mouth-1
             if dectPerVideo(kk,jj)==1
                 mouth_move = mouth_move+1;
             end
         end        
    end
    %%
    if nose_move >= 1
       dectPerVideo(:,rightSide:leftSide)=0;
    end
    %%
    if mouth_move >= 3 && nb_mouth==8
        dectPerVideo(:,jj)=0;
    end
    %% to delete the mouvement involes two many ROI which will be considered as head mouvement
    if move_entier>(nbRegion/2)
        dectPerVideo(:,jj)=0;
%         dectPerVideo(:,rightSide:leftSide)=0;
    end
end
%% selection part
% pos_fr = [0,0];
% for ii = 1:nbRegion  
%     restROI = 1:nbRegion;
%     restROI(ii) = []; 
%     for jj = 1: nbFrame
%          loopPos = [ii,jj];
%         if ismember(loopPos,pos_fr,'rows')
%             continue;
%         end
%         if dectPerVideo(ii,jj) ==1
%             % define the verify window 
%             rightSide = jj-ceil(window*r_w);
%             leftSide = jj + ceil(window*r_w);
%             if jj <=window*r_w
%                 rightSide = 1;
%             elseif jj> nbFrame - window*r_w
%                 leftSide = nbFrame;
%             end            
%             mm = 0;
%             for kk = 1: nbRegion-1
%                 nbPeak = 0;
%                 for qq = rightSide: leftSide
%                     if dectPerVideo(restROI(kk),qq) ==1
%                         pos_fr = [pos_fr;restROI(kk),qq];
%                         nbPeak = nbPeak+1;  
%                     end
%                 end
%                 if nbPeak >0
%                     mm=mm+1;
%                 end
%             end
%             if mm>=6 %mm<3 && 
%                dectPerVideo(ii,jj) = 0;
%             end
%         end
%     end
% end
%%
for jj = 1:nbFrame
    for pp = 1:nbRegion
        if dectPerVideo(pp,jj)==1
            spatialGlobal(jj) = 1 ;
            break;
        end
    end
end
spatialPerROI = dectPerVideo;

