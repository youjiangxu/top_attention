% ReDim        = 256;
% SampleKmeans = 256000;
% V_centers    = 256;
% layer        = 'spp';
% UCF101_Root  = './';
% Validation_Root = './';
function GetTrainTestQuantization_kc(UCF101_TDD_Root,splitnum,ReDim,V_centers,SampleKmeans)
    %%%%   load PCA information and centers
    load(['./PCA/',num2str(splitnum),'/PCA_vl_s', num2str(SampleKmeans), '_d', num2str(ReDim), '.mat']);   %% PCA transformation need not transpose
    load(['./Center/',num2str(splitnum),'/Center_vl_s', num2str(SampleKmeans), '_c', num2str(V_centers),'_d', num2str(ReDim),  '.mat']);  
    centers     = centers';
    kdtree      = vl_kdtreebuild(centers);
    numClusters = V_centers;


    if ~exist(['./VLAD_kQ/UCF/c_',num2str(V_centers), 'd_', num2str(ReDim),'/',num2str(splitnum)], 'dir')
        mkdir(['./VLAD_kQ/UCF/c_',num2str(V_centers), 'd_', num2str(ReDim),'/',num2str(splitnum)]);
    end


%%%%   -----compute vlad feature quantization per video----------------

%%%%   UCF101
    if ~exist('./Class_Ind/UCF101_Label.mat', 'file')
        LabelText   = importdata('./Class_Ind/UCF101_ClassInd.txt');
        LabelString = cell(101, 1);
        LabelNum    = zeros(101, 1);
        for i=1:101
            pos = strfind(LabelText{i}, ' ');
            LabelNum(i) = str2num(LabelText{i}(1:pos));
            LabelString{i} = LabelText{i}(pos+1:end);
        end
        save('./Class_Ind/UCF101_Label.mat', 'LabelNum', 'LabelString');
    else
        load('./Class_Ind/UCF101_Label.mat');
    end

    disp('UCF');
    quantization_root=['./VLAD_kQ/UCF/c_',num2str(V_centers), 'd_', num2str(ReDim),'/',num2str(splitnum)];

    tic;
        for i=1:length(LabelString) 
            classname=LabelString{i}
            if ~exist([quantization_root,'/',classname], 'dir')
                mkdir([quantization_root,'/',classname]);
            end
            Quantization = [];
    %disp(['Processing video:', validation_videos(i).video_name]);
            classfolder = dir([UCF101_TDD_Root,'/',classname,'/']);
            for j=3:length(classfolder)
                videoname=classfolder(j,1).name
                [UCF101_TDD_Root, '/', classname, '/', videoname]
                load([UCF101_TDD_Root, '/', classname, '/', videoname]);
                tdd=tw_ldd_feature;
                Feats = tdd;
                enc       = comp_vlad_k(Feats,centers, kdtree, single(pca_eigvalue), pca_eigvector, numClusters);
                Quantization = enc;
                Label = LabelNum(i);
                Names = videoname
                video_root=[quantization_root, '/', classname,'/',videoname]
                presave([quantization_root,'/',classname,'/',videoname], Quantization, Label, Names);
            end
        end
    toc;
end
