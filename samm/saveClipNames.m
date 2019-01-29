%% initialisation
%configuration;

for ii =1:nbSub
    if( isequal( subFiles( ii ).name, '.' )||...
        isequal( subFiles( ii ).name, '..')||...
        ~subFiles( ii ).isdir)              
        continue;
    end
    subName = subFiles(ii).name;
    vidFiles = dir([databasePath,subName,'/']);
    nbVid = length(vidFiles);
    for jj= 1:nbVid
        if( isequal( subFiles( jj ).name, '.' )||...
            isequal( subFiles( jj ).name, '..')||...            
            ~subFiles( jj ).isdir)               %
            continue;
        end
        
        indexChar_vid=[];
        vidIndex = vidFiles(jj).name;
        sub_vid_path = [subName,'/',vidIndex,'/'];
        vidPath = [databasePath,sub_vid_path];
        
        imgs = dir([vidPath,'*.jpg']);
        nbFrame = length(imgs);
        kk=1;
        while kk <= nbFrame
            if kk+length_w-1 <= nbFrame
                fstFr = kk;
                lastFr = kk+length_w-1;
            else
                if  nbFrame - kk >= ME_interval
                    fstFr = kk;
                    lastFr =nbFrame ;
                else
                    fstFr = kk-length_w + overlap;
                    lastFr =nbFrame ;
                end
            end
            resultname = regexp(imgs(fstFr).name,'.j','split');
            indexChar = char(resultname(1))    
            indexChar_vid=[indexChar_vid;indexChar];
            kk = kk+length_w-overlap;
        end
        indexWindowPath_vid = [indexWindowPath,subName,'/'];
        createFold(indexWindowPath_vid);
        save([indexWindowPath_vid,vidIndex,'_indexChar.mat'],'indexChar_vid');    
        ii
        jj
    end
    
   
 end
 