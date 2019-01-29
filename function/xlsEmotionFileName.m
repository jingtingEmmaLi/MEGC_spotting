%% to import different emotion filename 
%  bdd_info indicate the ordre of video, name of the video and the kind of
%  video
function bdd_info = xlsEmotionFileName(input,info)


    nbtense = size(info{1,2},1);
    tense = cell(1,nbtense);
   
    nbhapp = size(info{2,2},1);
    happ = cell(1,nbhapp);
    nbrepre = size(info{3,2},1);
    repre = cell(1,nbrepre);
    nbdisg = size(info{4,2},1);
    disg = cell(1,nbdisg);
    nbsurp = size(info{5,2},1);
    surp = cell(1,nbsurp);
    nbcompt = size(info{6,2},1);
    compt = cell(1,nbcompt);
    nbfear = size(info{7,2},1);
    fear = cell(1,nbfear);

    [~,~,raw] = xlsread(input);
    nbligne = size(raw,1);
      kt=1;kh=1;kr=1;kd=1;ks=1;kc=1;kf=1;  
    for ii = 1:nbligne-1        
        temp = raw{ii+1,12};
        sub = raw{ii+1,1};
        if sub<10
        subStr = ['0',num2str(sub)];
    else 
        subStr = num2str(sub);
    end
   ep = raw{ii+1,2};
   filename = ['sub',subStr,'_',ep];
        if strcmp(temp,'tense')
            tense{1,kt} = filename;
           kt=kt+1;
        elseif strcmp(temp,'happiness')
            happ{1,kh} = filename;
            kh=kh+1;
        elseif strcmp(temp, 'repression')
            repre{1,kr}= filename;
            kr=kr+1;
           
        elseif strcmp(temp,'disgust')
            disg{1,kd} = filename;
            kd=kd+1;
           
        elseif strcmp(temp, 'surprise')
            surp{1,ks}=filename;
            ks=ks+1;
            
        elseif strcmp(temp,'comtempt')
            compt{1,kc}= filename;
            kc=kc+1;
            
        elseif strcmp(temp,'fear')
            fear{1,kf} = filename;
            kf=kf+1;
            
        end
        
    end
    bdd_info = cell(7,3,1);
    bdd_info{1,3} = tense; bdd_info{1,1}=info{1,1};bdd_info{1,2}=info{1,2};
    bdd_info{2,3} = happ;  bdd_info{2,1}=info{2,1};bdd_info{2,2}=info{2,2};
    bdd_info{3,3} = repre; bdd_info{3,1}=info{3,1};bdd_info{3,2}=info{3,2};
    bdd_info{4,3} = disg;  bdd_info{4,1}=info{4,1};bdd_info{4,2}=info{4,2};
    bdd_info{5,3} = surp;  bdd_info{5,1}=info{5,1};bdd_info{5,2}=info{5,2};
    bdd_info{6,3} = compt; bdd_info{6,1}=info{6,1};bdd_info{6,2}=info{6,2};
    bdd_info{7,3} = fear;  bdd_info{7,1}=info{7,1};bdd_info{7,2}=info{7,2};
    
       
 end