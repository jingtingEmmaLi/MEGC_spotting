function distance_av2pt = displayDistance(nbPt,Vs,ptLoc,optionNor)
% nbPt = 50;
% Vs = Vs(:,1:2);
% ptLoc = apex;
% optionNor =1;
limitNb = size(Vs,1);
nbMax = nbPt;
nbMin = nbPt;
if ptLoc + nbPt > limitNb
    nbMax =0;
    while ptLoc+nbMax < limitNb
        nbMax = nbMax+1;
    end
end
if ptLoc-nbPt<1
    nbMin = 0;
    while ptLoc-nbMin>1
        nbMin = nbMin+1;
    end
end
d_av2pt = zeros(2,nbPt*2);
if ptLoc > limitNb 
  d_av2pt(2,:)=0;
  disp('!!!!!!!!!!attention!!no sufficient after offset!!!!!!!!!!!!!')

elseif ptLoc<=0
    d_av2pt(2,:)=0;
  disp('!!!!!!!!!!!attention!!no sufficient before onset !!!!!!!!!!!!!!!!!!')
   
else
posAvant = Vs(ptLoc-nbMin,:);
for nn = 1: nbPt*2
   if nn <= nbPt-nbMin
       d_av2pt(2,nn) = 0;
   elseif nn > nbPt+nbMax
       d_av2pt(2,nn) = 0;
   else
       pt2cal1 = Vs(ptLoc-nbPt+nn,:);
       d_av2pt(2,nn) = norm(pt2cal1 - posAvant);
   end     
   
   d_av2pt(1,nn) = nn;     
end
end
if optionNor ==1
    distance_av2pt = mapminmax(d_av2pt(2,:),0,1);
elseif optionNor ==0
    distance_av2pt = d_av2pt(2,:);
end

figure;
plot(d_av2pt(1,:),distance_av2pt,'-b*');
end
