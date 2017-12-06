function [ output_feature ] = feature_norm( input_feature, mode )
%%% mod=1, every row normalize
%%% mod=2, every column normalize
    if mode==2
        input_feature = input_feature';
    end
    rows = size(input_feature,1);   
    output_feature = input_feature;
    for i = 1:rows 
        if (norm(input_feature(i,:))==0) 
            output_feature(i,:)=input_feature(i,:);
        else
            output_feature(i,:)=input_feature(i,:)/norm(input_feature(i,:));
        end
    end
    if mode==2
        output_feature = output_feature';
    end
end

