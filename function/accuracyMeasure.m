function measurement_list = accuracyMeasure(tp,fp,nbGT,totalFrame)
% TPR : recall equals to tp/p
% FPR : equals to fp/n
% TNR : tn/n equals to 1-FPR
% FNR : miss rate equals to fn/p equals to 1- TPR
nbFalse = totalFrame-nbGT;
TPR = tp/nbGT;
FPR = fp/nbFalse;
TNR = 1-FPR; 
tn =  TNR*nbFalse;
FNR = 1-TPR;
fn = FNR*nbGT;


ACC = (tp+tn)/totalFrame;
precision = tp/(tp+fp);
F1_score = 2*tp/(2*tp+fp+fn);
measurement_list = [nbGT;nbFalse;totalFrame;tp;fp;fn;tn;TPR;FPR;FNR;TNR;ACC;precision;F1_score];