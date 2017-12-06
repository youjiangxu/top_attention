%% load data, process and perform clustering 
%% (1)L2 norm (2)PCA:get the transforamtion matrix (3)Dimension Reduction and Whiten (4)Kmeans
%%  !!!  feats is n*d matrix in this file, which is different from comp_vlad
%%%%  Parameters 
% ReDim        = 128;
% SampleKmeans = 256000;
% V_centers    = 256;
% layer        = 'fc6';

%%%%  L2 normalization

% colnums=size(Feats_Ori,2);
% Feats_L2_1     = feature_norm(Feats_Ori(:,1:(colnums/2)), 1);
% Feats_L2_2     = feature_norm(Feats_Ori(:,(colnums/2)+1:colnums), 1);
% Feats_L2       = [Feats_L2_1 Feats_L2_2];
function vl_pre_processing(Feats_Ori,splitnum,ReDim,V_centers,SampleKmeans)
    Feats_L2     = feature_norm(Feats_Ori, 1);

% Feats_L2     =Feats_Ori;

%%%%  PCA
    options.ReducedDim            = ReDim;
    [pca_eigvector, pca_eigvalue] = PCA(Feats_L2, options);
    mkdir (['PCA/',num2str(splitnum)]);
    save(['./PCA/',num2str(splitnum),'/PCA_vl_s', num2str(SampleKmeans),'_d', num2str(ReDim), '.mat'], 'pca_eigvector', 'pca_eigvalue');

%%%%  Dimensionality reduction and Whiten
    Feats_Redu   = Feats_L2*pca_eigvector;
    W_matrix     = repmat( 1./sqrt(pca_eigvalue), 1, size(Feats_Redu,1) );
    Feats_W      = W_matrix' .* Feats_Redu;	% whitening

%%%%  Kmeans and save centers
    disp('vl-kmeans');
    [centers, assignments] = vl_kmeans(Feats_W', V_centers, 'Initialization', 'plusplus') ; 
    centers = centers';
    mkdir (['Center/',num2str(splitnum)]);
    matname      = ['./Center/',num2str(splitnum),'/Center_vl_s', num2str(SampleKmeans),'_c', num2str(V_centers), '_d', num2str(ReDim)];
    eval(['save ',matname,'.mat  centers;']);
    size(centers)
end