function [feature,weight] = tw_top_LDD(cnn_feature,feature_conv,flength,stride,det)

    NUM_DIM = size(cnn_feature,3); 
    FRAME_NUM=size(cnn_feature,4);
    cnn_feature_pad=cat(4,cnn_feature(:,:,:,end),cnn_feature(:,:,:,end));
    cnn_feature=cat(4,cnn_feature,cnn_feature_pad);
    cnn_feature = permute(cnn_feature,[1,2,4,3]);
    feature_conv_pad=cat(4,feature_conv(:,:,:,end),feature_conv(:,:,:,end));
    feature_conv=cat(4,feature_conv,feature_conv_pad);
    for i = 1:stride:FRAME_NUM
        feature_sum(:,:,(i-1)/stride+1,:)=sum(cnn_feature(:,:,i:i+flength-1,:),3);
        top_weight_sum(:,:,:,(i-1)/stride+1)=mean(feature_conv(:,:,:,i:i+flength-1),4);
        top_weight(:,:,(i-1)/stride+1)=mean(top_weight_sum(:,:,:,(i-1)/stride+1),3);
    end
    size(top_weight)
    top_weight_01=top_weight;
    top_weight_01(top_weight<=det)=0;
    top_weight_01(top_weight>det)=1;
%     min_f=min(size(sal_feature,3),size(feature_sum,3));
    tw_feature_01=repmat(top_weight_01,[1,1,1,NUM_DIM]);
    feature=double(tw_feature_01).*feature_sum;
    feature = reshape(feature,[],NUM_DIM)';
    size(feature)
    top_weight=reshape(top_weight,[],1)';
    weight=top_weight(:,find(sum(abs(feature),1)~=0));
    feature(:,find(sum(abs(feature),1)==0))=[];
    size(feature)
end