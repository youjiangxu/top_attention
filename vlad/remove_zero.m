function [ outfeat ] = remove_zero( videoname,ori_feat )
%PRELOAD Summary of this function goes here
%   Detailed explanation goes here
    j=1;
    for k=1:size(ori_feat,2)
        enc=ori_feat(:,k);
        num=sum((enc==0));
        if(num==512)
            disp(['video name:', videoname,' ; index : ',num2str(k)]);
        else
            index(j)=k;
            j=j+1;
        end
    end
    outfeat     = ori_feat(:,index);
end
