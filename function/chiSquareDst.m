function D_sorted = chiSquareDst(histEntierVideo,k,currentInfo)
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
        if ii<k+1 && currentInfo(2)<k+1           % special situation for ME begins in 1->k interval
            tailFrame(:,:) = histEntierVideo(1,jj,:,:);
            headFrame(:,:) = histEntierVideo(ii+k,jj,:,:);
        elseif ii> nbFrame-k && currentInfo(3)> currentInfo(1)-k   % special situation for ME ends in nbframe-k -> nbframe interval
            tailFrame(:,:) = histEntierVideo(ii-k,jj,:,:); 
            headFrame(:,:) = histEntierVideo(nbFrame,jj,:,:);  
        elseif ii>k && ii<= nbFrame-k  % exclud the first and last K frames
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
