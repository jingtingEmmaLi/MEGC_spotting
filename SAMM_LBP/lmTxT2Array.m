function lm = lmTxT2Array(lmPath)
fileLM = fopen(lmPath);
a = textscan(fileLM, '%s');
fclose(fileLM);
nblm = size(a{1,1},1);
lm = zeros(nblm,1);
for ii = 1:nblm
    num_lm = str2double(a{1,1}(ii,:));
    if isnan(num_lm)
        lm(ii) = 0;
    else
        lm(ii) = num_lm;
    end
end