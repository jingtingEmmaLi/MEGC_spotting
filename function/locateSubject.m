%% divided the subject
%%
% configuration;
%%
function subdiff = locateSubject(filename)
avSub = '';
kk=1;
subdiff =[];
nbVideo = size(filename,1);
for nbseq = 1:nbVideo
    currentfile =char(filename(nbseq));
    %disp(['processing ',currentfile]);
    sub_ep = regexp(currentfile, '_', 'split');
    sub = char(sub_ep(1));
    if strcmp(sub,avSub)
        kk=kk+1;
    else 
        if nbseq ~= 1
%         disp(['processing ',currentfile]);
        subdiff = [subdiff; kk];
        kk=1;
        end
    end
    if nbseq == nbVideo
       subdiff = [subdiff; kk];
    end
    avSub = sub;
end
% save(['./data/subNumber_',bdd,'.mat'],'subdiff');
    