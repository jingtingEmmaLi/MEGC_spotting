%% transform video to data suitable for PCA
function [newvideo,nbFrame] = transformVideo(video)
[m,n,nbFrame] = size(video);
newvideo = zeros(nbFrame,m*n);
for i = 1:nbFrame
    k=1;
    for ii = 1:m
        for jj = 1:n
        newvideo(i,k) = video(ii,jj,i);
        k=k+1;
        end
    end
end
end