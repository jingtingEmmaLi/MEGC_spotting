%% feature to train : ROI selection
function [nb2train,index2train] = selectROI2train(pos_nose,pose_mouth, nbROI,nbRegion,au_info,au_side)
mouth_seg = (nbRegion-pose_mouth+1)/4;
nb2train = [];
index2train=[];
info_R = strfind(au_side, 'R');
info_L = strfind(au_side, 'L');
if ~isempty(find(au_info<6)) && isempty(find(au_info>=6))
    if isempty(info_R) && isempty(info_L)  
        nb2train = nbROI(1:pos_nose-1);
        index2train = 1:pos_nose-1;
    elseif ~isempty(info_R) || isempty(info_L)
        nb2train = nbROI(1:(pos_nose-1)/2);
        index2train = 1:(pos_nose-1)/2;
    elseif ~isempty(info_L) || isempty(info_R)
        nb2train = nbROI((pos_nose-1)/2+1:pos_nose-1);
        index2train = (pos_nose-1)/2+1:pos_nose-1;  
    end
elseif ~isempty(find(au_info>=10)) && isempty(find(au_info<10))

    if isempty(info_R) && isempty(info_L)          
        nb2train = nbROI(pose_mouth:nbRegion);
        index2train = pose_mouth:nbRegion;    
    elseif ~isempty(info_R) || isempty(info_L)
        nb2train = nbROI(pose_mouth:nbRegion);
        index2train = pose_mouth:nbRegion;   
        nb2train(mouth_seg+2:3*mouth_seg)=[];
        index2train (mouth_seg+2:3*mouth_seg)=[];
    elseif ~isempty(info_L) || isempty(info_R)        
        nb2train = nbROI(mouth_seg+pose_mouth:3*mouth_seg+pose_mouth);
        index2train = mouth_seg+pose_mouth:3*mouth_seg+pose_mouth;
       
    end
elseif (~isempty(find(au_info<10)) && ~isempty(find(au_info>=6)) ) || (~isempty(find(au_info>=10)) && ~isempty(find(au_info<6)))
    nb2train = nbROI;
    index2train = 1:nbRegion;  
    if ~isempty(info_R) || isempty(info_L) 
        if au_info(info_R)<=6
            nb2train((pos_nose-1)/2+1:pos_nose-1) =  [];  
            index2train((pos_nose-1)/2+1:pos_nose-1) =  [];  
        elseif au_info(info_R)>10
            nb2train(pose_mouth+mouth_seg+1:3*mouth_seg+pose_mouth-1) =  [];   
            index2train(pose_mouth+mouth_seg+1:3*mouth_seg+pose_mouth-1) =  []; 
        end
    elseif ~isempty(info_L) || isempty(info_R)
        if au_info(info_L)<=6
            nb2train(1:(pos_nose-1)/2+1) =  [];  
            index2train(1:(pos_nose-1)/2+1) =  []; 
        elseif au_info(info_L)>10
            nb2train(pose_mouth:mouth_seg+pose_mouth-1) =  []; 
            index2train(pose_mouth:mouth_seg+pose_mouth-1) =  []; 
            newEnd =nbRegion-mouth_seg;
            if newEnd-mouth_seg+2<= newEnd
            nb2train(newEnd-mouth_seg+2:newEnd) = [];
            index2train(newEnd-mouth_seg+2:newEnd) = [];
            end
        end
    end
end