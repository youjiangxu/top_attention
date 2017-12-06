% inputMap = neuronOutputMap;
% inputSize = outputSize;
% poolSize = 3;
% poolStride = 2;
% [outputMap, outputSize] = max_pooling(inputMap, inputSize, poolSize, poolStride);

function outputMap =  max_pooling(inputMap, poolSize, poolStride)
% =========================================================================
% INPUTS:
%        inputMap - input map of the max-pooling layer
%        inputSize - X-size(equivalent to Y-size) of input map
%        poolSize - X-size(equivalent to Y-size) of receptive field
%        poolStride -  the stride size between successive pooling squares.
% OUTPUT:
%        outputMap - output map of the max-pooling layer
%        outputSize - X-size(equivalently, Y-size) of output map
% =========================================================================
inputSize_h=size(inputMap,1);
outputSize_h=ceil((inputSize_h-poolSize)/poolStride)+1;
inputSize_w=size(inputMap,2);
outputSize_w=ceil((inputSize_w-poolSize)/poolStride)+1;
% outputMap = zeros(outputSize_h, outputSize_w, 'single');
outputMap = zeros(outputSize_h, outputSize_w);
for j = 1:outputSize_h
    for i = 1:outputSize_w
        starth = min(1 + (j-1)*poolStride,inputSize_h-poolSize+1);
        startw = min(1 + (i-1)*poolStride,inputSize_w-poolSize+1);      
        poolField=inputMap(starth:starth+poolSize-1,startw:startw+poolSize-1);
%         poolField = padMap(startY:startY+poolSize-1,startX:startX+poolSize-1,:);
%         poolOut = max(reshape(poolField, [poolSize*poolSize,inputChannel]),[],1);
        outputMap(j,i)=max(max(poolField));
%         outputMap(j,i,:) = reshape(poolOut,[1 1 inputChannel]);
    end
end