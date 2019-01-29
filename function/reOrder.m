%% re-order the filename
% to avoid the situation of '1,10,100,11,...,2,20,'
% thansform the order to ' 1,2,3,4,...100'
function [fileNames,nbFig]= reOrder(temp1)
 nbFig= length(temp1);
frOrder = zeros(1,nbFig);
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
        end
        reOrder = sort(frOrder);
        fileNames = [];
        for jj = 1:nbFig 
            figName = [seq, num2str(reOrder(jj)), '.jpg'];
            if jj == 1
                fileNames =  figName;
            else
                fileNames = char(fileNames, figName);
            end
        end
end