%% title to show frame info - onset apex offset
function titleInfo(frame2show,onset,apex,offset)
if frame2show < onset
    title(['Avant onset: ',num2str(frame2show),' frame']);
elseif frame2show == onset
    title(['Onset: ',num2str(frame2show),' frame']);
elseif frame2show > onset && frame2show < apex(1)
    title(['Onset-Apex: ',num2str(frame2show),' frame']); 
elseif frame2show == apex(1)
    title(['Apex: ',num2str(frame2show),' frame']);
elseif frame2show > apex(1) && frame2show< offset
    if size(apex,2)==1
        title(['Apex-Offset: ',num2str(frame2show),' frame']);
    elseif size(apex,2)==2
        if frame2show > apex(1) && frame2show<= apex(2)
            title(['Apex: ',num2str(frame2show),' frame']);
        elseif frame2show > apex(2)
            title(['Apex-Offset: ',num2str(frame2show),' frame']);
        end
    end
elseif frame2show == offset
    title(['Offset: ',num2str(frame2show),' frame']);
elseif frame2show > offset
    title(['Après offset: ',num2str(frame2show),' frame']);
end
end