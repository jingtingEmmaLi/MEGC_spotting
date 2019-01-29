function distance_av2pt = displayDistanceBy1stFr(nbPt,Vs,ptLoc)
% nbPt = number of point in interval;
% Vs = Vs(:,1:2);
% ptLoc =position of the first frame in the interval;
% optionNor =1;
limitNb = size(Vs,1);
nbMax = nbPt;
if ptLoc + nbPt > limitNb
    nbMax =0;
    while ptLoc+nbMax < limitNb
        nbMax = nbMax+1;
    end
end

d_av2pt = zeros(2,nbPt);

posAvant = Vs(ptLoc,:);
for nn = 1: nbPt
   if nn > nbMax
       d_av2pt(2,nn) = 0;
   else
       pt2cal1 = Vs(ptLoc+nn,:);
       d_av2pt(2,nn) = norm(pt2cal1 - posAvant);
   end     
   
   d_av2pt(1,nn) = nn;     
end
distance_av2pt = d_av2pt(2,:);

end

% figure;
% plot(d_av2pt(1,:),distance_av2pt,'-b*');

