% second standard: frame number
function [temporalGlobal, temporalPerROI]= temporalSelection(dectPerVideo,nbFrame,nbRegion,tempsInterval,window)

minframe = uint8(tempsInterval(1,1));
maxframe = uint8(tempsInterval(1,2));
temporalGlobal = zeros(nbFrame,1);

for mm = 1:nbRegion 
    jj=1;
    while jj <=nbFrame
        if dectPerVideo(mm,jj)==0
            jj=jj+1;
        elseif dectPerVideo(mm,jj)==1
            nb_frameTrueContinous = 0;
            if jj<nbFrame-window
                for qq = jj:jj+window
                    if dectPerVideo(mm,qq)==1
                        nb_frameTrueContinous = nb_frameTrueContinous+1;
                    end
                end
                if nb_frameTrueContinous<minframe
                    dectPerVideo(mm,jj:jj+window)=0;
                elseif nb_frameTrueContinous >maxframe
                    dectPerVideo(mm,jj:jj+window)=0;
                elseif nb_frameTrueContinous <=maxframe && nb_frameTrueContinous >=minframe
                    dectPerVideo(mm,jj:jj+window)= 1;
                end
                jj = jj+window+1;
            elseif jj>=nbFrame-window
                for qq = jj:nbFrame
                    if dectPerVideo(mm,qq)==1
                        nb_frameTrueContinous = nb_frameTrueContinous+1;
                    end
                end
                if nb_frameTrueContinous<minframe
                    dectPerVideo(mm,jj:nbFrame)=0;
                elseif nb_frameTrueContinous >maxframe
                    dectPerVideo(mm,jj:nbFrame)=0;
                elseif nb_frameTrueContinous <=maxframe && nb_frameTrueContinous >=minframe
                    dectPerVideo(mm,jj:nbFrame)= 1;
                end
                jj = nbFrame;   
            end
        end
    end
end
for mm = 1: nbRegion
    for nn=1:nbFrame
        if dectPerVideo(mm,nn)==1
            temporalGlobal(nn) = 1 ;
            break;
        end
        
    end
end
temporalPerROI = dectPerVideo;
