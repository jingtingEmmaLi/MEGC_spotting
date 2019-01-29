
%% threshold and detection
function [fig,detectionRst]=detectAvecSeuil(D_sorted,M,k,p,onset,offset,currentInfo,currentfile)
 
        nbFrame = size(D_sorted,1);
        D2process = D_sorted(:,1:M);
        iniDV = (1/M)* sum(D2process,2);
        ContDV_entier_temp = zeros(nbFrame,1);
         
            % because the constrasted distance is calculated by tail and head
            % frame, for the frame in position of 1->k,nbframe-k+1 --> nbframe,
            % the value is zero, this will cause the beginning and the ending
            % have the highest value
            % so right now the solution is set  1->k = iniDV(k+1), 
            % nbframe-k+1--> nbframe = iniDV(nbFrame-k)
       if nbFrame< 2*k+1
           k = ceil(k/2);
       end
       if currentInfo(2)<k+1 
           iniDV(nbFrame-k+1:end) = iniDV(nbFrame-k);
           for frPos = 1:nbFrame-k
               headFrame = iniDV(frPos+k);
               if frPos<k+1
                   tailFrame = iniDV(1);                 
               else
                   tailFrame = iniDV(frPos-k);
               end
               currentFrame = iniDV(frPos);
               ContrastedDV = currentFrame - 0.5*(tailFrame+headFrame);
               ContDV_entier_temp(frPos)=ContrastedDV;
           end
       elseif currentInfo(3)> currentInfo(1)-k
           iniDV(1:k) = iniDV(k+1);
           for frPos = 1+k:nbFrame
               tailFrame = iniDV(frPos-k);
               if frPos> nbFrame-k
                   headFrame = iniDV(nbFrame);
               else
                   headFrame = iniDV(frPos+k);
               end
               currentFrame = iniDV(frPos);
               ContrastedDV = currentFrame - 0.5*(tailFrame+headFrame);
               ContDV_entier_temp(frPos)=ContrastedDV;
           end
       elseif currentInfo(2)<k+1  && currentInfo(3)> currentInfo(1)-k
           for frPos = 1:nbFrame
               if frPos<k+1 
                   tailFrame = iniDV(1);
                   headFrame = iniDV(frPos+k); 
               elseif frPos> nbFrame-k 
                   tailFrame = iniDV(frPos-k);
                   headFrame = iniDV(nbFrame); 
                elseif frPos >=1+k && frPos<=nbFrame-k
                    tailFrame = iniDV(frPos-k);
                    headFrame = iniDV(frPos+k);
               end
               currentFrame = iniDV(frPos);
               ContrastedDV = currentFrame - 0.5*(tailFrame+headFrame);
               ContDV_entier_temp(frPos)=ContrastedDV;  
           end
       else
           iniDV(1:k) = iniDV(k+1);
            iniDV(nbFrame-k+1:end) = iniDV(nbFrame-k);
           for frPos = 1+k:nbFrame-k
               tailFrame = iniDV(frPos-k);
               headFrame = iniDV(frPos+k);
               currentFrame = iniDV(frPos);
               ContrastedDV = currentFrame - 0.5*(tailFrame+headFrame);
               ContDV_entier_temp(frPos)=ContrastedDV;
           end
       end
               

        
        ContDV_entier = ContDV_entier_temp;
        index = ContDV_entier<=0;
        ContDV_entier(index) = 0;
        
        cDV_mean = mean(ContDV_entier) ;
        cDV_max = max(ContDV_entier); 
        threshold = cDV_mean + p*(cDV_max-cDV_mean);
          
        % detected result
        posdetect = find(ContDV_entier>threshold);
        % ground truth
%         if offset == '\'
%             groundTruth = onset:onset+2*k;
%         else
%            groundTruth = onset-ceil(0.5*k):offset+ceil(0.5*k);
%         end
    if onset>ceil(k/2)  && offset+ceil(k/2)<=nbFrame        
        groundTruth = onset-ceil(k/2):offset+ceil(k/2);
    elseif onset<=ceil(k/2)
        groundTruth = 1:offset+ceil(k/2);
    elseif offset> nbFrame-ceil(k /2)
        groundTruth = onset-ceil(k/2):nbFrame;
    end
        
        % affichage du résultat
        fig=figure;
        plot(ContDV_entier);
        hold on;
        line_T = zeros(1,nbFrame);
        line_T(1:end) = threshold;
        plot(line_T);
        hold on;
        gtLeft = groundTruth(1);
        gtRight = groundTruth(end);
        height = max(ContDV_entier);
        
        
        x1 = [gtLeft,gtLeft];x2 = [gtRight,gtRight];
        y = [0,height];
        plot(x1,y,'r');hold on; plot(x2,y,'r');hold off;
        currentfile = strrep(currentfile,'_','\_'); 
        title([currentfile,'-',num2str(onset)]);
        % numérique result
        detectionRst{1,1} =posdetect ;
        detectionRst{1,2} =groundTruth ;
        math = ismember(posdetect,groundTruth);
        indexOne = find(math == 1);
        
        if isempty(indexOne)
            detectionRst{1,3}= 0;
        else 
             detectionRst{1,3}= 1;
        end
              
    end