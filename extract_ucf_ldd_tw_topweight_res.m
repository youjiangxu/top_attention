clc
clear
% a demo code for TDD extraction
% addpath('/usr/local/caffe.20150101-cuda6.5/matlab/caffe');
ucf_5c_res='/home/lyb/AAAI/TX/data/useful/ucf_5c_res';
% hmdb_sal='/mnt/data0/lyb/ZSC/MM/hmdb/hmdb_sal';
classlist = dir([ucf_5c_res,'/']);
flength = 3;
stride  = 1;
det = 0.5;
tic;
for i=3:length(classlist)
    classname=classlist(i,:).name;
    mkdir (['ucf_twmean',num2str(det),'_sum',num2str(flength),'topweight_ldd_res/',classname])
    videolist = dir([ucf_5c_res,'/',classname,'/']);
    for j=1:length(videolist)
        if(~strcmp(videolist(j,1).name,'.') && ~strcmp(videolist(j,1).name,'..'))
            videoname=videolist(j,:).name;
            vid_name=[ucf_5c_res,'/',classname,'/',videoname]      
            display('Extract spatial TDD...');
%             scale = 3;
%             layer = 'conv5';
%             sal_list=dir([hmdb_sal,'/',classname,'/',videoname(1:end-4),'.avi/']);
%             length(sal_list)
%             sal_feature=[];
%             for k=3:length(sal_list)
%                 saltemp=imread([hmdb_sal,'/',classname,'/',videoname(1:end-4),'.avi/',sal_list(k,:).name]);
%                 saltemp=imresize(saltemp,[240,320],'bilinear');
%                 sal= mean_pooling(saltemp, 32, 32);
%                 sal(sal<=det)=0;
%                 sal(sal>det)=1;
%                 sal_feature(:,:,k-2)=sal;
%             end
%             size(sal_feature)
            load(vid_name);
            [feature_conv_normalize_1, feature_conv_normalize_2] = FeatureMapNormalization(feature_conv);
%             [feature_conv_normalize_1_1, feature_conv_normalize_1_2] = FeatureMapNormalization(feature_conv_normalize_1);
            [tw_ldd_feature,weight] = tw_top_LDD(feature_conv_normalize_1,feature_conv,flength,stride,det);
            save(['./ucf_twmean',num2str(det),'_sum',num2str(flength),'topweight_ldd_res/',classname,'/',videoname(1:end-4),'.mat'],'tw_ldd_feature','weight','-v7.3');
        end
    end
end
disp('extract tw linepooling feature done');
toc;
