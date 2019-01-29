%% to import seperate different emotion 
%  bdd_info indicate the ordre of video, name of the video and the kind of
%  video
 function bdd_info = xlsEmotionInfo(input)
%input = './data/CASME_SectionA_modified.xls';
    [~,~,raw] = xlsread(input);
    nbligne = size(raw,1);
    bdd_info = cell(7,2);
    tense = [];
    happiness = [];
    repression = [];
    disgust = [];
    surprise = [];
    comtempt = [];
    fear = [];
    
    for ii = 1:nbligne-1        
        temp = raw{ii+1,12};
        
        if strcmp(temp,'tense')
            tense = [tense; ii];
           
        elseif strcmp(temp,'happiness')
            happiness = [happiness;ii];
            
        elseif strcmp(temp, 'repression')
            repression= [repression;ii];
           
        elseif strcmp(temp,'disgust');
            disgust = [disgust;ii];
           
        elseif strcmp(temp, 'surprise')
            surprise=[surprise;ii];
            
        elseif strcmp(temp,'comtempt')
            comtempt= [comtempt;ii];
            
        elseif strcmp(temp,'fear')
            fear = [fear;ii];
            
        end
        
    end
    bdd_info{1,2} = tense; bdd_info{1,1} = 'tense';
    bdd_info{2,2} = happiness; bdd_info{2,1} = 'happiness';
    bdd_info{3,2} = repression;bdd_info{3,1} = 'repression';
    bdd_info{4,2} = disgust; bdd_info{4,1} = 'disgust';
    bdd_info{5,2} = surprise; bdd_info{5,1} = 'surprise';
    bdd_info{6,2} = comtempt; bdd_info{6,1} = 'comtempt';
    bdd_info{7,2} = fear; bdd_info{7,1} = 'fear';
       
end