%% temporal selection per roi
%%
function temporalMerge= doMerge(temporalGlobal,nbFrame,window)

maxMEdist = 2*window;
minMEsz = 1/4*window;
maxMEsz = 2*window;
%% 
% first to count the peak interval number

jj =1;
noteFrame = [];
while jj <=nbFrame
    if temporalGlobal(jj)==0
        jj=jj+1;
    elseif temporalGlobal(jj)==1 
        kk = 0;
        while jj+kk+1 <= nbFrame && temporalGlobal(jj+kk+1)==1  
                kk=kk+1;
                
            end
        
        noteFrame = [noteFrame;jj,jj+kk];
        jj = jj+kk+1;
    end
end
doMerge = 1;
while doMerge == 1
    doMerge =0;
    for ii = 1: size(noteFrame,1)-1
        mid1 = (noteFrame(ii,2)-noteFrame(ii,1))/2+noteFrame(ii,1);
        mid2 = (noteFrame(ii+1,2)-noteFrame(ii+1,1))/2+noteFrame(ii+1,1);
        if mid2-mid1 <maxMEdist && (noteFrame(ii+1,2)-noteFrame(ii,1) <= maxMEsz)
            noteFrame(ii,:) = [noteFrame(ii,1),noteFrame(ii+1,2)];
            noteFrame(ii+1,:) = [];
            doMerge =1;
            break;
        end
    end
end
% notejj = [];
% for jj = 1: size(noteFrame,1)
%     if noteFrame(jj,2)-noteFrame(jj,1) < minMEsz 
%         notejj = [notejj, jj];
%     end
% end
% noteFrame(notejj,:) = [];
noteFrame
 nbpeakGlobal = size(noteFrame,1);
 temporalGlobal = zeros(nbFrame,1);
for dd = 1: nbpeakGlobal     
    beginFr =noteFrame(dd,1) ;
    endFr = noteFrame(dd,2) ;
    temporalGlobal(beginFr: endFr) =1;     
 end
  
%% bug -one video one ME and adjust interval size
% finalPeak = [];
% nn=1;
% r_oneME = 4/3;
% while nn <=nbFrame 
%     if temporalGlobal(nn) ==0
%          nn =nn+1;
%     elseif temporalGlobal(nn) ==1
%         kk = 1;
%         while temporalGlobal(nn+kk)==1
%             kk=kk+1;
%         end
%         finalPeak = [finalPeak;nn,kk];
%         nn = nn+kk;
%     
%     end    
% end
% finalPeak
% if ~isempty(finalPeak)
% maxPeak = max(finalPeak(:,2));
% indexFinal =[];
% for gg = 1: size(finalPeak,1)
%     if finalPeak(gg,2) ==maxPeak;
%         indexFinal =[indexFinal;gg];
%     end
% end
% for hh = 1 : size(indexFinal,1)
% if maxPeak<=(r_oneME)*window && maxPeak>=(1/2)*window
%     beginFinal = finalPeak(indexFinal(hh),1);
%     endFinal = beginFinal+(r_oneME)*window;
%     if endFinal>nbFrame
%         endFinal = nbFrame;
%     end
%     temporalGlobal(beginFinal: endFinal) =1;
% elseif  maxPeak<(1/2)*window
%     half2add = floor(((r_oneME)*window -maxPeak)/2);
%     beginFinal = finalPeak(indexFinal(hh),1)-half2add;
%     endFinal = beginFinal+(r_oneME)*window;
%     if beginFinal<1
%         beginFinal =1;
%     end
%     if endFinal>nbFrame
%         endFinal = nbFrame;
%     end
%     temporalGlobal(beginFinal: endFinal) =1;
% elseif maxPeak>(r_oneME)*window
%     half2cut = ceil((maxPeak-(r_oneME)*window)/2);
%     beginFinal = finalPeak(indexFinal(hh),1)+half2cut;
%     endFinal = beginFinal+(r_oneME)*window;
%     if beginFinal<1
%         beginFinal =1;
%     end
%     if endFinal>nbFrame
%         endFinal = nbFrame;
%     end
%     temporalGlobal(beginFinal: endFinal) =1;
% end
% end
%  finalPeak(indexFinal,:) = []
% for pp = 1: size(finalPeak,1)
%     temporalGlobal(finalPeak(pp,1): finalPeak(pp,1)+finalPeak(pp,2)-1) =0;
% end

temporalMerge = temporalGlobal;        