function plotROIresult(index_roi,nbROI,dectPerVideo,spatialPerROI,temporalPerROI,spaTemPerROI )
nbplot = size(index_roi,2);
nbRow = 4;
 nbFrame = size(dectPerVideo,2);
figure;
kk=1;
for jj = 1:nbRow
    for ii = 1:nbplot
    subplot(nbRow,nbplot,kk)
    if jj==1
        plot(dectPerVideo(index_roi(ii),:));
        title(['ROI',num2str(nbROI(index_roi(ii)))])
        axis([1 nbFrame 0 1])
    elseif jj==2
        plot(spatialPerROI(index_roi(ii),:));
        title('spatial')
        axis([1 nbFrame 0 1])
    elseif jj==3
        plot(temporalPerROI(index_roi(ii),:));
        title('temperal')
        axis([1 nbFrame 0 1])
    elseif jj ==4
        plot(spaTemPerROI(index_roi(ii),:));
        title('spatial->temporal')
        axis([1 nbFrame 0 1])
%     elseif jj ==5
%         plot(temSpaPerROI(index_roi(ii),:));
%         title('temporal->spatial')
%         axis([1 nbFrame 0 1])
    end
    kk = kk+1;
    end
end
    
   