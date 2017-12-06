clc
clear
% a demo code for TDD extraction
addpath('/mnt/data0/lyb/ZSC/caffe/matlab');
% setenv('KMP_DUPLICATE_LIB_OK','TRUE');
% addpath('/usr/local/caffe-mpi_parallel/matlab/caffe');
hmdb_video_root='/mnt/data0/lyb/ZSC/MM/ucf/UCF-101';
model_def_file = './nets/ResNet-152-deploy-5c.prototxt';
model_file = './models/ResNet-152-model.caffemodel';
use_gpu = 1
if exist('use_gpu', 'var') && use_gpu
    caffe.set_mode_gpu();
    gpu_id = 0;  % we will use the first gpu in this demo
    caffe.set_device(gpu_id);
else
    caffe.set_mode_cpu();
end
phase = 'test'
net = caffe.Net(model_def_file, model_file, phase);
classlist = dir([hmdb_video_root,'/']);
for i=3:length(classlist)
    classname=classlist(i,:).name;
    mkdir (['/home/lyb/ZSC/useful/ucf_5c_res/',classname])
    videolist = dir([hmdb_video_root,'/',classname,'/']);
    for j=1:length(videolist)
        if(~strcmp(videolist(j,1).name,'.') && ~strcmp(videolist(j,1).name,'..'))
            videoname=videolist(j,:).name;
            vid_name=[hmdb_video_root,'/',classname,'/',videoname]
%             sizes = [8,8; 11.4286,11.4286; 16,16; 22.8571,24;32,34.2587];
            sizes_vid = [240,320];
            display('Extract RES 4b35...');

            scale = 1;
            layer = '4b35';
            feature_conv = RGBCNNFeature(vid_name, sizes_vid(scale,1), sizes_vid(scale,2), net);
            save(['/home/lyb/ZSC/useful/ucf_5c_res/',classname,'/',videoname(1:end-4),'.mat'],'feature_conv','-v7.3');
        end
    end
end


