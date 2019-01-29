function drawImpulsion(a,color)
index1= find(a>0);
nbFrame = size(a,1);

    x1 = [index1(1),index1(1)];
y=[0,1];
plot(x1,y,color)
hold on 
    x2 = [index1(end),index1(end)];
 plot(x1,y,color)
 hold on
 x3=[index1(1),index1(end)];
 y2=[1,1];
 plot(x3,y2,color)
 hold on
end
axis([1 nbFrame 0 1.2])