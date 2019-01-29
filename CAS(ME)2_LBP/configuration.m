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

upperPath = 'D:/Jingting/CAS(ME)2/';%'../'
% addpath(genpath(upperPath));
databasePath =  'D:/Jingting/CAS(ME)2/rawpic/';

%% general setting 

bdd = 'CAS(ME)2';   %'CAS1SECA'
inputXlS = [upperPath,'casModifiedInfo.xlsx'];
colomnXls = 6;
casMEinfo = importdata([upperPath,'casInfo.mat']);
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
N = 10;
k = ceil(0.5*(N-1)) ;% interval to calculate
p=0.15;     % parameter of thresholding beta = mean-p*(max-min)
M = 36/3;   % the percentage of selecting maximal values
nn=1;
%%
outputChiSqDst = [upperPath,'chiSquare_distance/'];
createFold(outputChiSqDst);
outputSpot =[upperPath,'posSpot/',num2str(p),'/']; 
createFold(outputSpot)


%%
set_inteval = 15;
shortLength2delete =6;
ratio_threshold = 0.5;

%%
length_w = 30; % 1000ms = 30frame --> 30fps
overlap = 9; % 300ms - ME duration
indexWindowPath = [upperPath,'indexWindow/'];
createFold(indexWindowPath);
