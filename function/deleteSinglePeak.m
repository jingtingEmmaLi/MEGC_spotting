%% spatial constraint posNose2zero,posMouth2zero,posEye2zero
function finalGlobal = deleteSinglePeak(temporalGlobal,nbFrame,window,r_w_frame)
r_w= r_w_frame;

jj=1;
countPeakInROI = [];
while jj <=nbFrame  
    if temporalGlobal(jj)==0
        jj=jj+1;
    elseif temporalGlobal(jj)==1 
        nb_frameTrueContinous = 0;
        posframe = [];
        if jj<nbFrame-window*r_w
            for qq = jj:jj+window*r_w
                if temporalGlobal(qq)==1
                    nb_frameTrueContinous = nb_frameTrueContinous+1;
                    posframe = [posframe,qq];
                end
            end
            countPeakInROI = [countPeakInROI;jj,nb_frameTrueContinous] ;
            jj = jj+window*r_w+1;
        elseif jj>=nbFrame-window*r_w
            for qq = jj:nbFrame
                if temporalGlobal(qq)==1
                    nb_frameTrueContinous = nb_frameTrueContinous+1;
                    posframe = [posframe,qq];
                end
            end
            countPeakInROI = [countPeakInROI;jj,nb_frameTrueContinous] ;
            jj = nbFrame;  
        end
    end
end
%%

 if ~isempty(countPeakInROI)
        indexMax = find(countPeakInROI(:,2)>floor(window/9) ) ;
        inde2zero = countPeakInROI(:,1);
        if ~isempty(indexMax) && size(countPeakInROI,1)>1
            inde2zero(indexMax) = [];
            nbPeak = size(inde2zero,1);
                %to choose 
            for pp = 1:nbPeak
                if inde2zero(pp)+window*r_w<nbFrame
                    temporalGlobal(inde2zero(pp):inde2zero(pp)+window*r_w) =0;
                else
                    temporalGlobal(inde2zero(pp):nbFrame) =0;
                end
            end
        end
        
    end
finalGlobal=temporalGlobal;


