%% function to record the file number in the database
function nbfile = readBDDfileNb(subFacePath,inputXLS,k)
%  inputXLS='../main/data/CASME_SectionA.xls';
[~,~,raw] = xlsread(inputXLS);
nbVideo = size(raw,1)-1;
% nbVideo = 96;
nbfile = zeros(nbVideo,3);
for ii = 1: nbVideo
    [nbSub, nbEP, onset,~,offset] = xlsImport(inputXLS,ii);
    facePath = [subFacePath, nbSub,'/',nbEP,'/'];
    temp1 = dir([facePath,'*.jpg']);
    [~,nbfig]= reOrder(temp1);
    if offset  =='\'
        offset  =onset+2*k+1;
    end
    nbfile(ii,:) = [nbfig,onset, offset];
end

        
end