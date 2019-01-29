%% re-order the filename
% to avoid the situation of '1,10,100,11,...,2,20,'
% thansform the order to ' 1,2,3,4,...100'
function reOrderandName(fullpath)
temp1 = dir([fullpath,'*.jpg']);
nbFig= length(temp1);
frOrder = zeros(1,nbFig);
deg_10 = floor(log10(nbFig));
for ii = 1:nbFig 
    if ismember('-',char(temp1(ii).name))
        splitRelsut1 = regexp(char(temp1(ii).name),'-','split');
        seq = [char(splitRelsut1(1)),'-'];
    else
        splitRelsut1 = regexp(char(temp1(ii).name),'mg','split');
        seq = [char(splitRelsut1(1)),'mg'];
    end
    
    splitRelsut2 = regexp(char(splitRelsut1(2)),'.j','split');
    frOrder(ii) = str2double(splitRelsut2(1));  
    zero_char = [];
    newfileName=[];
    nb_deg = floor(log10(frOrder(ii)));
    if nb_deg<deg_10
        for jj = 1:deg_10-nb_deg
           zero_char = [zero_char,'0']; 
        end
    end
    newfileName = [zero_char,num2str(frOrder(ii)),'.jpg'];
    movefile( [fullpath,temp1(ii).name],  [fullpath,newfileName]);
end

     