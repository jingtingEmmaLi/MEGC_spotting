%% configuration
% already get the image info(ROI images and landmarks position)
% setting the parameters of including;
% PCA, distance normalization,  
% data for machine learning: training and testing 
%%
 clc;
 clear;
%  close all; 
%% add path

upperPath = 'D:/Jingting/samm_cropped/';%'../'
% addpath(genpath(upperPath));
databasePath =  'D:/Jingting/samm_cropped/cropped/';

%% general setting 

bdd = 'SAMM'%_cropped';   %'CAS1SECA'

%%

subFiles = dir(databasePath);
nbSub  = length(subFiles);
%% block video generation
   % if is CASSECB, there is no need to re-ordre the file, image can be blocked directly
X_ratio = 0.2;%0.2;
Y_ratio = 0.3;%0.3;
BlockupperPath = [upperPath,'blockVid/'];
createFold(BlockupperPath);
outputLMpath = [upperPath,'landmarks/'];
outputLBP = [upperPath,'LBP_uniform/'];
createFold(outputLBP);
%%  LBP SETTING 
nbSamples = 8;
radius = 3;
type = 'u2';
modeHist = 'nh';   % uniform

%% thresholding and detection setting 
N = 61;
k = ceil(0.5*(N-1)) ;% interval to calculate
p=0.05;     % parameter of thresholding beta = mean-p*(max-min)
M = 36/3;   % the percentage of selecting maximal values
nn=1;
%%
outputChiSqDst = [upperPath,'chiSquare_distance/'];
createFold(outputChiSqDst);
outputSpot =[upperPath,'posSpot/',num2str(p),'_',num2str(M),'/']; 
createFold(outputSpot)

%%
sammMEinfo = importdata([upperPath,'sammInfo.mat']);
inputXlS = [upperPath,'sammModifiedInfo.xlsx'];
colomnXls =5;
%%
set_inteval = 100;
shortLength2delete =20;
ratio_threshold = 0.5;
%%
length_w = 200; % 1000ms = 200frame --> 200fps
overlap = 60; % 300ms - ME duration
%%
indexWindowPath = [upperPath,'indexWindow/'];
createFold(indexWindowPath);
