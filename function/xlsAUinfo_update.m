%% to import the AU info form Excel table
% _au_info_ indicate the distribution of Action unit
% _au_side_ indicate the location of action unit; N mean no obviously
% deviation; L means left side and R means right sides
%%
function [au_info,au_side] = xlsAUinfo_update(input,nb,colomnXls)
% clear au_info au_side
% upperPath = 'e:/pcaMEs/';%'../'
% bdd = 'CAS2,samm cas(me)2';
% input = [upperPath,'main/data/',bdd,'.xlsx'];nb=9;

    [~,~,raw] = xlsread(input);
    order = nb;
    temp = char(raw{order,colomnXls});
    info_R = strfind(temp, 'R');
    info_L = strfind(temp, 'L');
    info_plus = strfind(temp,'+');
    if ~isempty(info_plus) && isempty(info_R) && isempty(info_L) % eg:1+2
        au_temp=regexp(temp,'+','split');
        for ii = 1: size(au_temp,2)
            au_info(ii) = str2double(au_temp(ii));
             au_side(ii)= 'N';
        end
        %au_side = 'N';
    elseif ~isempty(info_plus) && ~(isempty(info_R) && isempty(info_L)) % eg: R1+R2 or 1+r2+12 etc.
        au_temp=regexp(temp,'+','split');
        for ii = 1: size(au_temp,2)
           huha = char(au_temp(ii));
           lenTemp = size(huha,2);
           info_R_single = strfind(huha, 'R');
           info_L_single = strfind(huha, 'L');
           if ~(isempty(info_R_single) && isempty(info_L_single))
                au_info(ii) = str2double(huha(2:lenTemp));
                 if ~isempty(info_R)
                     au_side(ii) = 'R';  % indicate the AU locate on the right side
                 elseif ~isempty(info_L)
                     au_side(ii)  = 'L';  % indicate the AU locate on the left side
                 end
                
           else
               au_info(ii) = str2double(huha(1:lenTemp));
                au_side(ii)= 'N';
           end
        end  
%         if ~isempty(info_R)
%             au_side = 'R';  % indicate the AU locate on the right side
%         elseif ~isempty(info_L)
%             au_side = 'L';  % indicate the AU locate on the left side
%         end
%    
    elseif  isempty(info_plus) && ~(isempty(info_R) && isempty(info_L)) % eg: R12
        lenTemp = size(temp,2);
        au_info(1) = str2double(temp(1,2:lenTemp));
        if ~isempty(info_R)
            au_side(1) = 'R';  % indicate the AU locate on the right side
        elseif ~isempty(info_L)
            au_side(1) = 'L';  % indicate the AU locate on the left side
        end
    elseif isempty(info_plus) && isempty(info_R) && isempty(info_L) %eg:12
        au_info = temp;
        au_side = 'N';
    end
% end