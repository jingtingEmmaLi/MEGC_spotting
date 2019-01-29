function emotion_spot = emotionAnalyse(emotionInfo,nbVideo,nbTP,nbFP,nbGTperline,trueFileInfo)
nbEmotion = size(emotionInfo,1);
emotion_spot = cell(nbEmotion,16);
emotionTpfpGtNb = zeros(nbEmotion,4);
emotionMeasure = zeros(nbEmotion,14);
for ii = 1:nbVideo
    for jj = 1: nbEmotion
        whichEmotion = find(emotionInfo{jj,2}==ii);
        if ~isempty(whichEmotion)
            emotionTpfpGtNb(jj,1) = emotionTpfpGtNb(jj,1)+nbTP(ii);  % tp
            emotionTpfpGtNb(jj,2)= emotionTpfpGtNb(jj,2)+nbFP(ii);   % fp
            emotionTpfpGtNb(jj,3) = emotionTpfpGtNb(jj,3)+nbGTperline(ii);  % ground truth
            emotionTpfpGtNb(jj,4) = emotionTpfpGtNb(jj,4)+trueFileInfo(ii,1); % total frame in emotion type
        end    
    end    
end

for ii = 1:nbEmotion
emotionMeasure(ii,:)= accuracyMeasure(emotionTpfpGtNb(ii,1),emotionTpfpGtNb(ii,2),emotionTpfpGtNb(ii,3),emotionTpfpGtNb(ii,4));    
emotion_spot{ii,1} = emotionInfo{ii,1};
emotion_spot{ii,2} = size(emotionInfo{ii,2},1);
for jj = 1:14
emotion_spot{ii,jj+2} = emotionMeasure(ii,jj);
end
end