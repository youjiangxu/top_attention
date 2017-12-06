function [feature_sum] = tw_top_LDD(norm_feature,flength,stride)

    NUM_DIM = size(norm_feature,3); 
    FRAME_NUM=size(norm_feature,4);
    norm_feature_pad=cat(4,norm_feature(:,:,:,end),norm_feature(:,:,:,end));
    norm_feature=cat(4,norm_feature,norm_feature_pad);
    norm_feature = permute(norm_feature,[1,2,4,3]);
    
    for i = 1:stride:FRAME_NUM
        feature_sum(:,:,(i-1)/stride+1,:)=sum(norm_feature(:,:,i:i+flength-1,:),3);
        
    end
    
    feature_sum = reshape(feature_sum,[],NUM_DIM)';
    
    size(feature_sum)
end