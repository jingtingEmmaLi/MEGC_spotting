function [max_value, indRow,indCol]= findMax(matrice)
temp = matrice(:);
[max_value,index_temp] = max(temp);
[indRow,indCol] = ind2sub(size(matrice),index_temp);
end