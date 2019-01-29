
%% threshold and detection
function posdetect = detectAvecSeuil_longVid(D_sorted,M,k,p)
 
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
       
       iniDV(1:k) = iniDV(k+1);
       iniDV(nbFrame-k+1:end) = iniDV(nbFrame-k);
       for frPos = 1+k:nbFrame-k
           tailFrame = iniDV(frPos-k);
           headFrame = iniDV(frPos+k);
           currentFrame = iniDV(frPos);
           ContrastedDV = currentFrame - 0.5*(tailFrame+headFrame);
           ContDV_entier_temp(frPos)=ContrastedDV;
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
  
              
    end