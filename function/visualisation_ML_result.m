% visualization of ML result
function visualisation_ML_result(data2test,label2test,info2test,predicted_label,nblabel1,ROI2show,fileName,file2save,varargin)

varargin=[];
label1_predict = find(predicted_label);
label1_location = find(label2test);
 
totalNbVideo = size(info2test,1);

i = 1; % local variable
newinfo_test = zeros(totalNbVideo+1,1);
newinfo_test(2:end) = info2test(:,4)-(info2test(1,4)-info2test(1,3));
frames_captured_in_video = zeros(totalNbVideo,1);


if numel(varargin) ==0
    frameloc_test = cell(totalNbVideo,1);
    for nbSeq = 1:totalNbVideo
       frameloc_test{nbSeq,1} = 1:info2test(nbSeq,2);
    end
elseif numel(varargin) ==1
    frameloc_test = varargin;
end

for nbvideo = 1:size(info2test,1)
    
    if ROI2show == 5
     interval = 2:19;
     weight = data2test(newinfo_test(nbvideo)+1,1);
 elseif ROI2show ==6
     interval = 21:38;
     weight = data2test(newinfo_test(nbvideo)+1,20);
 elseif ROI2show ==11
     interval = 40:57;
     weight = data2test(newinfo_test(nbvideo)+1,39);
    end 
 
    index_videoName = info2test(nbvideo,1);
    videoName = char(fileName{index_videoName,1});
    videoName = strrep(videoName,'_','\_'); 
    frames_currentVideo = frameloc_test{nbvideo,1};
    
    while i<=size(label1_predict,1)
        if label1_predict(i) >newinfo_test(nbvideo) && label1_predict(i) <=newinfo_test(nbvideo+1)
                i=i+1;
        else
            break;
        end
    end

    detected_frame = sum(frames_captured_in_video);
    frames_captured_in_video(nbvideo) = i-detected_frame-1 ; 
    fig = figure;
    nbfig = frames_captured_in_video(nbvideo);
    kk=1; % space to show the detect result
    nbfig_perRow = 5;
    if nbfig>nbfig_perRow
        while kk*nbfig_perRow<nbfig
            kk=kk+1;
        end
    end
    nn = 1;  % space to show the ground truth
    if nblabel1 >nbfig_perRow
         while nn*nbfig_perRow<nblabel1
            nn=nn+1;
        end
    end
    for j = 1:nbfig
        subplot(kk+nn,nbfig_perRow,j);        
        plot(data2test(label1_predict(j+detected_frame),interval))
        if j ==1
            ylabel(['test video : ', num2str(nbvideo)]);
            xlabel(['CN : ',num2str(weight) ])
        end
        axis([0 18 0 1])
        grid on;
        title(num2str(frames_currentVideo(label1_predict(j+detected_frame)-newinfo_test(nbvideo))));
    end 
    mm=1;
    for j = nbfig_perRow*kk+1:nbfig_perRow*(kk+nn)
        subplot(kk+nn,nbfig_perRow,j);        
        plot(data2test(label1_location(nblabel1*(nbvideo-1)+mm),interval));       
        title(num2str(frames_currentVideo(label1_location(nblabel1*(nbvideo-1)+mm)-newinfo_test(nbvideo))));
        if j == nbfig_perRow*kk+1
            ylabel(['ground truth of ',num2str(nbvideo),' video']);
            xlabel(['CN : ',num2str(weight) ])
        end        
        axis([0 18 0 1]);
        grid on;
        if mm == nblabel1
            xlabel(videoName);
        end
        mm=mm+1;
    end 
    if file2save ==1
        filename = ['./output/svmresult_LOOCV/',num2str(info2test(nbvideo)),'video2test_ML_result'];
    elseif file2save ==2
        filename = ['./output/RFresult_LOOCV/',num2str(info2test(nbvideo)),'video2test_ML_result'];
    end 
    saveas(fig,filename); 
    saveas(fig,filename,'jpeg');    
end

end

