% [Diag,Vs,Diag_reduit,Vs_reduit] = slg_acp(D,Nb_app,variance_expliquee)
% Principal Component Analysis on D values, with Nb_app experiments
% and a useful energy of variance_expliquee
% Return eigenvalues Diag, eigenvectors Vs and eigenvalues Diag_reduit, 
% eigenvectors Vs_reduit of useful energy

 function [Diag,Vs,energie,Diag_reduit,Vs_reduit] = slg_acp(D,Nb_app,variance_expliquee)

%% Singular Value Decomposition

SigmaT = (1/Nb_app)*(D')*D;
%[Vt Diag] = eig(SigmaT);
[Vt, Diag] = svd(SigmaT);

%% Vs column normalization

Vs_nonNorm = D*Vt;
[Vs_L, Vs_C] = size(Vs_nonNorm);
sprintf('%d',Vs_L);
Vs = Vs_nonNorm;
for i=1:Vs_C
    [Vs(:,i)] = Vs(:,i)./norm(Vs(:,i));
end

%% Sort

lambda = sum(Diag);
[lambda_trie, position] = sort(lambda,'descend');
Vs_trie = Vs(:,position);
Diag_trie = diag(lambda_trie);

Vs = Vs_trie;
Diag = Diag_trie;

%% Keep useful energy

Somme = sum(lambda_trie);
Seuil = variance_expliquee*Somme;

Somme_Tmp = lambda_trie(1);
t=1;
%fprintf('PCA : with first component -> %2.1f%% energy \n',Somme_Tmp*100/Somme);
energie(t) = Somme_Tmp*100/Somme;
while (Somme_Tmp<Seuil)
    t = t+1;
    Somme_Tmp = Somme_Tmp+lambda_trie(t);
   % fprintf('PCA : with %d components -> %2.1f%% energy \n',t,Somme_Tmp*100/Somme);
    energie(t) = Somme_Tmp*100/Somme;
end

Diag_reduit = Diag_trie(1:t,1:t);
Vs_reduit = Vs_trie(:,1:t);
 end