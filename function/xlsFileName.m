%% to import all emotion filename 
%  bdd_info indicate the ordre of video, name of the video and the kind of
%  video

 function fileNameSet = xlsFileName(input)

%  input = './data/CASME_SectionB.xls';
    [~,~,raw] = xlsread(input);
    nbligne = size(raw,1);
    fileNameSet = cell(nbligne-1,1);  
    for ii = 1:nbligne-1        
        temp = raw{ii+1,12};
        sub = raw{ii+1,1};
        if sub<10
            subStr = ['0',num2str(sub)];
        else 
            subStr = num2str(sub);
        end
   ep = raw{ii+1,2};
   filename = ['sub',subStr,'_',ep];
   fileNameSet{ii,1}=filename  ;
   end
