clc
clear
% counting num of descriptors
descriptors_path='/home/lyb/AAAI/TX/ucf_res_code/ucf_twmean0.5_sum3topweight_ldd_res';
task_type = 'tw_ldd'
classlist = dir([descriptors_path,'/']);
tic;
all_descriptor = 0;
all_video = 0;
for i=3:length(classlist)
    classname=classlist(i,:).name;
	mkdir (['./stat_num_descriptors/',task_type,'/'])
	
    videolist = dir([descriptors_path,'/',classname,'/']);
	num_descriptors = cell(length(videolist),2);
	total_descriptors = 0;
	ave_descriptors = 0;
	num_video = 0;
    for j=1:length(videolist)
        if(~strcmp(videolist(j,1).name,'.') && ~strcmp(videolist(j,1).name,'..'))
            videoname=videolist(j,:).name
			load([descriptors_path,'/',classname,'/',videoname(1:end-4),'.mat']);
			%num = size(ldd_feature,2);
			num = size(tw_ldd_feature,2);
			num_descriptors{j,1}=videoname;
			num_descriptors{j,2}=num;
			total_descriptors = total_descriptors+num;
			num_video = num_video+1;
			
        end
    end
	all_descriptor = all_descriptor + total_descriptors;
	all_video = all_video + num_video;
	ave_descriptors = total_descriptors/num_video
	save(['./stat_num_descriptors/',task_type,'/',classname,'.mat'],'num_descriptors','total_descriptors','ave_descriptors','-v7.3');
	clear total_descriptors,ave_descriptors
end
toc;

disp(['all descriptors:',int2str(all_descriptor),'; total video:',int2str(all_video)])

