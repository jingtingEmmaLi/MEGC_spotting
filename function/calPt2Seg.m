%% calculate the distance between one point and a segment fixed by two point
% input:three points
% output: distance

function distance = calPt2Seg(p1,p2,p3)
seg12 = p2-p1;
seg13 = p3-p1;
dst12 = norm(seg12);
dst13 = norm(seg13);
angle213 = acos(dot(seg12,seg13)/(dst12*dst13));
distance = dst13*sin(angle213);
end