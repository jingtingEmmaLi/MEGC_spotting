%% 
function measureSaved2Xls(filename,varargin)
% result1 = normrnd(1,0.5,[14,1]);
% result2= normrnd(1,0.5,[14,1]);
% result3= normrnd(1,0.5,[14,1]);
% result4 = normrnd(1,0.5,[20,1]);
% filename = 'balala.xls';
nVarargs = length(varargin);

result1 =  varargin{1};

result2 = [];result3 =[];result4 = [];result5 =[];result6 = [];result7 =[];
if  nVarargs ==3      
    result2 = varargin{2};
    result3 = varargin{3};

   
elseif nVarargs ==5 
    result2 = varargin{2};
    result3 = varargin{3};
    result4 = varargin{4};
    result5 = varargin{5};
elseif nVarargs ==6
    result2 = varargin{2};
    result3 = varargin{3};
    result4 = varargin{4};
    result5 = varargin{5};
    result6 = varargin{6};
    
    elseif nVarargs ==7 
    result2 = varargin{2};
    result3 = varargin{3};
    result4 = varargin{4};
    result5 = varargin{5};
    result6 = varargin{6};
    result7 = varargin{7};
   
end
%% per video1
result2str1 = num2str(result1);

titletable = {'accuracy measurement table'};
xlswrite(filename, titletable, 'perVideo1','A1:a1')
row2 = {'T',result2str1(1,:),'F',result2str1(2,:),'total',result2str1(3,:)};
xlswrite(filename, row2, 'perVideo1','A2:F2');
ligne1et2 = {'TP',result2str1(4,:);'FN',result2str1(6,:);'TPR',result2str1(8,:);'FNR',result2str1(10,:)};
xlswrite(filename, ligne1et2,'perVideo1', 'A3:B6');
ligne3et4 = {'FP',result2str1(5,:);'TN',result2str1(7,:);'FPR',result2str1(9,:);'TNR',result2str1(11,:)};
xlswrite(filename, ligne3et4,'perVideo1', 'C3:D6');
row7 = {'ACC',result2str1(12,:),'precision',result2str1(13,:),'F1-score',result2str1(14,:)};
xlswrite(filename, row7,'perVideo1', 'A7:F7');

ideal2str3 = num2str(result3');

titletable = {'ideal situation '};
xlswrite(filename, titletable,'perVideo1', 'A8')
row2 = {'T',ideal2str3(1,:),'F',ideal2str3(2,:),'total',ideal2str3(3,:)};
xlswrite(filename, row2, 'perVideo1','A9:F9');
ligne1et2 = {'TP',ideal2str3(4,:);'FN',ideal2str3(6,:);'TPR',ideal2str3(8,:);'FNR',ideal2str3(10,:)};
xlswrite(filename, ligne1et2,'perVideo1', 'A10:B13');
ligne3et4 = {'FP',ideal2str3(5,:);'TN',ideal2str3(7,:);'FPR',ideal2str3(9,:);'TNR',ideal2str3(11,:)};
xlswrite(filename, ligne3et4,'perVideo1', 'C10:D13');
row7 = {'ACC',ideal2str3(12,:),'precision',ideal2str3(13,:),'F1-score',ideal2str3(14,:)};
xlswrite(filename, row7,'perVideo1', 'A14:F14');

%% per video 2
if ~isempty(result2)
result2str2 = num2str(result2);

titletable = {'accuracy measurement table'};
xlswrite(filename, titletable,'perVideo2', 'A1:a1')
row2 = {'T',result2str2(1,:),'F',result2str2(2,:),'total',result2str2(3,:)};
xlswrite(filename, row2, 'perVideo2','A2:F2');
ligne1et2 = {'TP',result2str2(4,:);'FN',result2str2(6,:);'TPR',result2str2(8,:);'FNR',result2str2(10,:)};
xlswrite(filename, ligne1et2,'perVideo2', 'A3:B6');
ligne3et4 = {'FP',result2str2(5,:);'TN',result2str2(7,:);'FPR',result2str2(9,:);'TNR',result2str2(11,:)};
xlswrite(filename, ligne3et4,'perVideo2', 'C3:D6');
row7 = {'ACC',result2str2(12,:),'precision',result2str2(13,:),'F1-score',result2str2(14,:)};
xlswrite(filename, row7,'perVideo2', 'A7:F7');


titletable = {'ideal situation '};
xlswrite(filename, titletable,'perVideo2', 'A8')
row2 = {'T',ideal2str3(1,:),'F',ideal2str3(2,:),'total',ideal2str3(3,:)};
xlswrite(filename, row2, 'perVideo2','A9:F9');
ligne1et2 = {'TP',ideal2str3(4,:);'FN',ideal2str3(6,:);'TPR',ideal2str3(8,:);'FNR',ideal2str3(10,:)};
xlswrite(filename, ligne1et2,'perVideo2', 'A10:B13');
ligne3et4 = {'FP',ideal2str3(5,:);'TN',ideal2str3(7,:);'FPR',ideal2str3(9,:);'TNR',ideal2str3(11,:)};
xlswrite(filename, ligne3et4,'perVideo2', 'C10:D13');
row7 = {'ACC',ideal2str3(12,:),'precision',ideal2str3(13,:),'F1-score',ideal2str3(14,:)};
xlswrite(filename, row7,'perVideo2', 'A14:F14');
end
%% per  frame
result2str3 = num2str(result4);

titletable = {'accuracy measurement table'};
xlswrite(filename, titletable,'perFrame', 'A1')
row2 = {'T',result2str3(1,:),'F',result2str3(2,:),'total',result2str3(3,:)};
xlswrite(filename, row2, 'perFrame','A2:F2');
ligne1et2 = {'TP',result2str3(4,:);'FN',result2str3(6,:);'TPR',result2str3(8,:);'FNR',result2str3(10,:)};
xlswrite(filename, ligne1et2,'perFrame', 'A3:B6');
ligne3et4 = {'FP',result2str3(5,:);'TN',result2str3(7,:);'FPR',result2str3(9,:);'TNR',result2str3(11,:)};
xlswrite(filename, ligne3et4,'perFrame', 'C3:D6');
row7 = {'ACC',result2str3(12,:),'precision',result2str3(13,:),'F1-score',result2str3(14,:)};
xlswrite(filename, row7,'perFrame', 'A7:F7');

ideal2strPerFrame = num2str(result5');

titletable = {'ideal situation '};
xlswrite(filename, titletable,'perFrame', 'A8')
row2 = {'T',ideal2strPerFrame(1,:),'F',ideal2strPerFrame(2,:),'total',ideal2strPerFrame(3,:)};
xlswrite(filename, row2, 'perFrame','A9:F9');
ligne1et2 = {'TP',ideal2strPerFrame(4,:);'FN',ideal2strPerFrame(6,:);'TPR',ideal2strPerFrame(8,:);'FNR',ideal2strPerFrame(10,:)};
xlswrite(filename, ligne1et2,'perFrame', 'A10:B13');
ligne3et4 = {'FP',ideal2strPerFrame(5,:);'TN',ideal2strPerFrame(7,:);'FPR',ideal2strPerFrame(9,:);'TNR',ideal2strPerFrame(11,:)};
xlswrite(filename, ligne3et4,'perFrame', 'C10:D13');
row7 = {'ACC',ideal2strPerFrame(12,:),'precision',ideal2strPerFrame(13,:),'F1-score',ideal2strPerFrame(14,:)};
xlswrite(filename, row7,'perFrame', 'A14:F14');

%% emotion 
result6measure = {'','nb','nbGT','nbFalse','totalFrame','tp','fp','fn','tn','TPR','FPR','FNR','TNR','ACC','precision','F1_score'};
xlswrite(filename, result6measure, 'detectionPerEmotion','A1:P1');
xlswrite(filename, result6, 'detectionPerEmotion','A2:P8');

xlswrite(filename, result5, 'detectionPerEmotion','C9:P9');

%% constraint contribution
if ~isempty(result7)
% result2str5 = num2str(result7);

row2ligneB ={'Nb of TPperFrame conserved','Ratio','Nb of FPperFrame deleted','Ratio ',...
    'nbGT','nbFalse','totalFrame','tp','fp','fn','tn','TPR','FPR','FNR','TNR','ACC','precision','F1_score'} ;
xlswrite(filename, row2ligneB,'constraint contribution', 'B2:s2');
row3ligneA = {'Original recognition';'Temporal selection';'Spatial selection';'Merge'; 'Fusion'};
xlswrite(filename, row3ligneA, 'constraint contribution','A3:A7');
xlswrite(filename, result7, 'constraint contribution','B3:o7') %s
xlswrite(filename, result5, 'constraint contribution','B8:s8') %f

end
disp('finish to write the info into Excel')
