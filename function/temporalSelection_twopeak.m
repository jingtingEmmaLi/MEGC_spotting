% second standard: frame number
function [temporalGlobal, temporalPerROI]= temporalSelection_twopeak(dectPerVideo,nbFrame,nbRegion,tempsInterval,window)

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
            nb_frameTrueafter=0;
            posframe = [];
            if jj<nbFrame-window
                for qq = jj:jj+window/2
                    if dectPerVideo(mm,qq)==1
                        nb_frameTrueContinous = nb_frameTrueContinous+1;
                        posframe = [posframe,qq];
                    end
                end
%                 nb_frameTrueContinous
                if nb_frameTrueContinous<minframe
                    dectPerVideo(mm,jj)=0;
                    jj=jj+1;
                elseif nb_frameTrueContinous >maxframe
                    dectPerVideo(mm,jj:jj+window)=0;
                     jj = jj+window+1;
                elseif nb_frameTrueContinous <=maxframe && nb_frameTrueContinous >=minframe
                    jj = jj+window/2+1;
                    for qq = jj: jj+window/3
                        if dectPerVideo(mm,qq)==1
                            nb_frameTrueafter = nb_frameTrueafter+1;
                            posframe = [posframe,qq];
                        end
                    end
                    if nb_frameTrueafter<minframe
                        dectPerVideo(mm,jj)=0;
                        jj=jj+1;
                    elseif nb_frameTrueafter >maxframe
                        dectPerVideo(mm,jj:jj+window)=0;
                        jj = jj+window+1;
                    elseif nb_frameTrueafter <=maxframe && nb_frameTrueContinous >=minframe
                        jj = jj+window+1;
                        dectPerVideo(mm,jj:posframe(end))= 1;                        
                    end                    
                end                 
                    
            elseif jj>=nbFrame-window
                for qq = jj:nbFrame
                    if dectPerVideo(mm,qq)==1
                        nb_frameTrueContinous = nb_frameTrueContinous+1;
                    end
                end
                if nb_frameTrueContinous<minframe
                    dectPerVideo(mm,jj:nbFrame)=0;
                     jj=jj+1;
                elseif nb_frameTrueContinous >maxframe
                    dectPerVideo(mm,jj:nbFrame)=0;
                    jj = nbFrame;   
                elseif nb_frameTrueContinous <=maxframe && nb_frameTrueContinous >=minframe
                    dectPerVideo(mm,jj:nbFrame)= 1;
                    jj = nbFrame;   
                end
                
            end
        end
    end
end
for nn=1:nbFrame
    for mm = 1: nbRegion   
        if dectPerVideo(mm,nn)==1 
            temporalGlobal(nn) = 1 ;
            break;
        end
    end
end
%% qualify lissage 
ii=1;
while ii<nbFrame
    if temporalGlobal(ii) == 1
        jj = 1;
        while temporalGlobal(ii+jj) == 1
            jj=jj+1;
        end
        if jj>window || jj< minframe
            temporalGlobal(ii:ii+jj)=0;
            dectPerVideo(:,ii:ii+jj)=0;
        end
        ii = ii+jj+1;
    else
        ii = ii+1;
    end   
end


%%

temporalPerROI = dectPerVideo;
