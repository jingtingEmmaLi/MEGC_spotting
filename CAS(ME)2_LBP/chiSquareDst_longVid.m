function D_sorted = chiSquareDst_longVid(histEntierVideo,k)
[nbFrame, nbBlock,~,~] = size(histEntierVideo);
D_ini = zeros(nbFrame, nbBlock);

for ii = 1:nbFrame
    for jj = 1: nbBlock
        image2lbp(:,:) = histEntierVideo(ii,jj,:,:);
        [m,n] = size(image2lbp);
        tailFrame = zeros(m,n);
        headFrame = zeros(m,n);
        if nbFrame<2*k+1
            k = ceil(k/2);
        end
        % situation: nbFrame>=2k+1 
        % all the frames in the video 
        if ii>k && ii<= nbFrame-k
            tailFrame(:,:) = histEntierVideo(ii-k,jj,:,:);
            
            headFrame(:,:) = histEntierVideo(ii+k,jj,:,:);       
        end 
        averageFF = 0.5*(tailFrame+headFrame);
        chi2_distance = pdist2(averageFF',image2lbp','chisq'); % need to clearify the parameter of function pdist2
        D_ini(ii,jj)=chi2_distance; 
    end
    clear image2lbp tailFrame headFrame averageFF chi2_distance
end     

D_sorted = sort(D_ini,2,'descend');
end
