%% configuration
% already get the image info(ROI images and landmarks position)
% setting the parameters of including;
% PCA, distance normalization,  
% data for machine learning: training and testing 
%%
 clc;
 clear;
%  close all; 
warning off;
%% add path

upperPath = 'D:/Jingting/CAS(ME)2/';%'../'
% addpath(genpath(upperPath));
databasePath =  'D:/Jingting/CAS(ME)2/rawpic/';

%% general setting 

bdd = 'CAS(ME)2';   %'CAS1SECA'
roiType = 'patial';% 'patial'  'entier'
%%

subFiles = dir(databasePath);
nbSub  = length(subFiles);

%% ROI info
% video2delete = importdata([upperPath,'main/data/Info2del_',bdd,'.mat']);
if strcmp(roiType,'entier')
    nbROI =importdata([upperPath,'nbROIentier.mat']);
elseif strcmp(roiType,'patial')
    nbROI =importdata([upperPath,'nbROIpatial.mat']);
end
nbROI = nbROI';
nbRegion = size(nbROI,2);
sizeROI = 10;
mode = 'center';  % upper right 'UR'; lower left 'LL'; center 'center'
ROIupperPath = [upperPath,'cutImage/',bdd,'/size_',num2str(sizeROI),'/'];
createFold(ROIupperPath);
outputLMpath = [upperPath,'landmarks/'];

% k=10;
%% sliding window setting 
length_w = 30; % 1000ms = 30frame --> 30fps
overlap = 9; % 300ms - ME duration
ME_interval  = 9;
window = ceil(ME_interval*1);
%% chosen method
chosen_method = 'PCA'; % 'AE'

% PCA
if strcmp(chosen_method,'PCA')
    fileType = '';
    outPCApath = [upperPath,'PCA_Output/',bdd,'/size_',num2str(sizeROI),'/'];
    createFold(outPCApath);
    variance_expliquee = 0.95;
    
% Auto-encoder
elseif strcmp(chosen_method,'AE')
     fileType = '_AE';
     AEpath = 'D:/project/autoEncoder4ROI/';
    im2AEPath = [AEpath,'vidPerROI/'];
    encoderPath = [AEpath,'encoderOut/'];
end

%% distance calculate
distancePath = [upperPath,'distancePerFrame',fileType,'/',bdd,'/size_',num2str(sizeROI),'/'];
createFold(distancePath);
%%  distance normalization
nb2max = ME_interval/2;
CN_seuil =10;
if isempty(CN_seuil)
    normType = '';
else 
    normType = '_CNseuil';
end

distanceNormPath = [upperPath,'distancePerFrame_norm',normType,fileType,'/',bdd,'/size_',num2str(sizeROI),'/'];
createFold(distanceNormPath);

%%
indexWindowPath = [upperPath,'indexWindow/'];
createFold(indexWindowPath);
%%
casMEinfo = importdata([upperPath,'casInfo.mat']);
%%
vecto2testPath = [upperPath,'vec2test',fileType,'/',bdd,'/size_',num2str(sizeROI),'/'];
createFold(vecto2testPath);
%%
inputXlS = [upperPath,'casModifiedInfo.xlsx'];
colomnXls = 6;
%% hammerstain Model 

trainVecComposition  =''; 'filter_gene'; %_NoDistCnPente_filter
%%

seuil_indensity = 0.9;
sampleRate2train = 8;
vec2trainPath = [upperPath,'vec2train',fileType,'/',bdd,'/size_',num2str(sizeROI),'/distSeuil_',num2str(seuil_indensity),'/'];
createFold(vec2trainPath);
nbIntervalPt = 9;
label2one = ceil(nbIntervalPt/3);


%% predict path
predictLabelPath = [upperPath,'predictLabel',fileType,'/',bdd,'/size_',num2str(sizeROI),'/distSeuil_',num2str(seuil_indensity),'/'];
createFold(predictLabelPath);

%% fusion result
spa_switch = 1;
cn_ratio = 0;
r_w_ROI = 1/6;
r_w_frame = 1/3;
fusionPath = [upperPath,'fusionResult',fileType,'/',bdd,'/size_',num2str(sizeROI),'/distSeuil_',num2str(seuil_indensity),'/boolen011_cn_0.4_rwori16_rw13_spaon/'];
createFold(fusionPath);

%%
set_inteval = 15;
shortLength2delete =6;
ratio_threshold = 0.5;

