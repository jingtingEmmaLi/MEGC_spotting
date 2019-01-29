%% compare with groundtruth
function [detect_nb,falsePstv,detectInfo] = analyseRT(length_interval,nbROI,detectionME,test_feature_info,fileOrder,fileName,bdd_pathway,outputPath)

nbvideo = size(fileOrder,2);
nbRegion = size(nbROI,2) ;
k =1/2*(length_interval-1);
detect_nb = 0;
falsePstv = 0;
detectInfo = zeros(nbvideo,1);
kk=1;
for ii = 1:nbvideo
   
    ii
   
    nbFrame = test_feature_info(ii,2);
    groundTruth = zeros(nbFrame,1);
    
    %% save the onset offset information
    
    if  ii<nbvideo && strcmp(fileName(ii),fileName(ii+1))  
       [~, ~, onset(kk), ~, offset(kk)] = xlsImport(bdd_pathway,fileOrder(ii));
       kk=kk+1;   
       continue
    else
        [~, ~, onset(kk), ~, offset(kk)] = xlsImport(bdd_pathway,fileOrder(ii));
    end    
        
       for mm= 1: size(onset,2)
           if strcmp(offset(mm),'\')
               offset(mm) = onset(mm)+length_interval;
           end
           if onset(mm)>k
               groundTruth(onset(mm)-k:offset(mm)+k) = 1;
           elseif onset(mm)<=k
               groundTruth(1:offset(mm)+k) = 1; 
           end  
       end
     if  ii<nbvideo && ~strcmp(fileName(ii),fileName(ii+1))  
         kk=1;
     end           
     
    firstFrame = uint64(test_feature_info(ii,4)/nbRegion-test_feature_info(ii,2)+1);
    lastFrame = uint64(test_feature_info(ii,4)/nbRegion);
    detectPerVideo = detectionME(firstFrame:lastFrame);
    
%% detection number
    nbFig = lastFrame- firstFrame+1;
    
    if size(onset,2) >1
             
        for mm = 1:size(onset,2)
            jj=1;
            while jj<=nbFig           
                if detectPerVideo(jj)==1 && jj>=onset(mm)-k && jj<=offset(mm)+k
                    detect_nb = detect_nb+1;
                    jj = offset(mm)+k+1;
                    detectInfo(ii)=1;
                elseif detectPerVideo(jj)==1 && jj< onset(mm)-k  && mm>1  && jj> offset(mm-1)+k
            
                    falsePstv = falsePstv+1;
                    jj = jj + length_interval;
                    if jj >onset(mm)-k
                        jj = onset(mm)-k;
                    end
                elseif detectPerVideo(jj)==1 && jj> offset(mm)+k  && mm<size(onset,2) && jj< onset(mm+1)-k     
                    falsePstv = falsePstv+1;
                    jj = jj + length_interval;  
                else 
                    jj=jj+1;
                end
            end
        end
        elseif size(onset,2)==1
            jj=1;
             while jj<=nbFig
            
               if detectPerVideo(jj)==1 && jj>=onset-k && jj<=offset+k
                    detect_nb = detect_nb+1;
                    jj = offset+k+1;
                    detectInfo(ii)=1;
               elseif detectPerVideo(jj)==1 && jj< onset-k  
            
                    falsePstv = falsePstv+1;
                    jj = jj + length_interval;
                    if jj >onset-k
                        jj = onset-k;
                    end
               elseif detectPerVideo(jj)==1 && jj> offset+k    
                    falsePstv = falsePstv+1;
                    jj = jj + length_interval;  
               else 
                    jj=jj+1;
               end  
               
            end
      
    end
    detect_nb
    falsePstv
% %     
    
    
    %% affichage
    fig=figure;
    videoName = strrep(fileName(ii),'_','\_'); 
    plot(groundTruth);
    hold on;
    plot(detectPerVideo);
    title(videoName);
    hold off
    
    figureName = [outputPath,char(fileName(ii))];
    
    saveas(fig,figureName); 
    saveas(fig,figureName,'jpeg'); 
    close
 clear onset offset    
end
   

% end
