%% to import specifique AU and emotion 
%  ordreSet indicate the ordre of video, name of the video and the kind of
%  video
function ordreSet = xlsEmotionAU(input,emotion, AU)

    [~,~,raw] = xlsread(input);
    nbligne = size(raw,1);
    ordreSet = [];
    for ii = 1:nbligne-1        
        temp = raw{ii+1,12};    
        if strcmp(temp,emotion)
            [au_info,~] = xlsAUinfo(input,ii);
            if au_info ==AU
              ordreSet = [ordreSet,ii];
            end
        end
    end
          
end