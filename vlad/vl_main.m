clc
clear
%%%%  Global Parameters
ReDim        = 512;
% ReDim        = 128;
V_centers    = 256;
SampleKmeans = 256000;
% layer        = 'spp';


%%%   Folder Containing the Quantization Frame Mats
UCF101_TDD_Root  = '/home/lyb/AAAI/TX/ucf_res_code/ucf_twmean0.5_sum3topweight_ldd_res';
% UCF101_TDDsumabsdif_Root  = '/home/lyb/ZSC/TDD_code/TDD-master/tempdata/ucf_tddsumabsdif_vggframedif1';
for splitnum =1:3
    %%  RandomSample
    disp('Sample');
    tic;
        random_Sample_train(UCF101_TDD_Root,splitnum);
    toc;

    %%  Install VL_Feat Library
    run('vlfeat-0.9.20/toolbox/vl_setup');

    %%  Load data (each row is a sample,each column is a feature)
    load(['./ucf_Sample/ucf_tddSample',num2str(splitnum),'.mat']);
    Feats_Ori = lddSample;  clear lddSample;

    index = randperm(size(Feats_Ori,1));  %%%  random sample the data for random kmeans initialization
    Feats_Ori = Feats_Ori(index(1:SampleKmeans), :);

    %% L2-nomralization - PCA with whitening - Prepare data for kmeans
    disp('PCA');
    tic;
        vl_pre_processing(Feats_Ori,splitnum,ReDim,V_centers,SampleKmeans);   %% kmeans center post-processing
    toc;


    %% Get the final representation for VLAD 
    disp('Final Representation');
    tic;
        GetTrainTestQuantization_kc(UCF101_TDD_Root,splitnum,ReDim,V_centers,SampleKmeans);
    toc;
    %%
    disp('build_train_test_DataSet');
    tic;
        buildTDD_train_test(splitnum,ReDim);
    toc;
end