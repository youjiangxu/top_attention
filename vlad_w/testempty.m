clear
clc
testempyt_ROOT='/media/lyb/ZSC/DataSet/ucf_vlcdfeat_vgg/spatial1';
class_folder = dir([testempyt_ROOT,'/']);
% sum = 0;
% num = 0;
for i = 3:length(class_folder)
    classname = class_folder(i,1).name;
    videofolder = dir([testempyt_ROOT,'/',classname,'/']); 
%     classname
    for j = 3:length(videofolder)
        videoname = videofolder(j,1).name;
        load([testempyt_ROOT,'/',classname,'/',videoname]);
        num=size(vlcd_feature_spatial_1,2);
%         if(num==0)
%             dip('0000000')
%         end
%         
        for k=1:size(vlcd_feature_spatial_1,2)
            enc=vlcd_feature_spatial_1(:,k);
            num=sum((enc==0));
%             num=(sum(enc==0));
            if(num==512)
                disp(['video name:', videoname,' ; index : ',num2str(k)]);
            end
        end
%         if(size(result,1)==0)
%             sum=sum+1;
%         end
    end
end