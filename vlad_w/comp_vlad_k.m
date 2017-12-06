function enc  = comp_vlad_k(Feats, weight,centers, kdtree, pca_eigvalue, pca_eigvector, numClusters)
%	 Parameters
%    Feats             d*n dimension data with d features and n samples
%    NumFeats          number of features, here is n
%    centers           d*c dimension with d features and c centers
%    kdtree            kdtree structure of the centers
%                      kdtree = vl_kdtreebuild(centers); centers:d*c
%    pca_eigvalue      pca eigenvalue    d*reduce
%    pca_eigvector     pca_engivector    reduce*1
%    numClusters       cluster numbers   
   % disp('Quantization');
    numFeats     = size(Feats, 2);
    
    %%%%  L2 normalization
    Feats_L2     = feature_norm(Feats, 2);
%     Feats_L2     = Feats;
    %%%%  PCA and Whiten 
    Feats_PCA    = pca_eigvector' * Feats_L2;	%PCA
%     disp(['Dimension after pca:', size(Feats_PCA,1), size(Feats_PCA,2)]);
    Feats_W      = repmat( 1./sqrt(pca_eigvalue), 1, numFeats ) .* Feats_PCA;	% whitening
%     disp(['Dimension after whiten:', size(Feats_W,1), size(Feats_W,2)]);
    
%     Feats_repeat=Feats_W();
    knear        = 5; 
%   nn           = vl_kdtreequery(kdtree, centers, Feats_W) ;        %KD-tree search, d*n dimension
    [index, distance] = vl_kdtreequery(kdtree, single(centers), Feats_W, 'NumNeighbors', knear) ;% 建立kdtree的索引  index存feats_w到各中心点的最knear紧邻的索引

%     assignments  = zeros(numClusters, numFeats);  %行数为中心点数   列为特征的个数
    assignments  = single(zeros(numClusters, numFeats));
    for kk=1:knear
        nn           = double(index(kk, :)); %取第KK行（当kk=1时取得是每个特征最近的中心点的index）
        assignments(sub2ind(size(assignments), nn, 1:length(nn))) = 1; %assignment 对每个特征最近邻的第KK个中心点index赋值为1 
    end
    
    assignments=assignments.*repmat(weight, numClusters, 1);
%     assignments = assignments/knear;%assignment表示每个特征最近邻的前knear个赋值为1（注：列数==特征的个数 即每一列表示一个特征：每一列有knear个1其他为0）vald要求每一列的sum=1 （注：也可以不平均 每个k紧邻可以权值不同 但列sum==1）
    
    enc      = vl_vlad(Feats_W, single(centers), assignments, 'NormalizeComponents');%vald 量化
%     enc      = vl_vlad(Feats_W, centers, assignments);

%   enc = sign(enc) .* sqrt(abs(enc));	% power normalization
%   enc = enc/norm(enc);	% L2 normalization
end