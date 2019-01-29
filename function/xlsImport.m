
%% function to import the Micro-expression video sequence info
% 
function [sub, EPxx, onset, apex, offset] = xlsImport(input,nb)
    [~,~,raw] = xlsread(input);
    order = nb+1;
    if raw{order,1}<10
        sub = ['sub0',num2str(raw{order,1})];
    else 
        sub =['sub',num2str(raw{order,1})];
    end
    
    EPxx = raw{order,2};
    onset = raw{order,4};
    offset = raw{order,7};
    if raw{order,6} == '\'
        apex = raw{order,5};
    else
        apex = [raw{order,5},raw{order,6}];
    end
end
