% function FCNNFeature = RGBCNNFeature(vid_name, use_gpu, NUM_HEIGHT, NUM_WIDTH, model_def_file, model_file, gpu_id)
function FCNNFeature = RGBCNNFeature(vid_name, NUM_HEIGHT, NUM_WIDTH, net)
%% Input video
vidObj = VideoReader(vid_name);
if vidObj.NumberOfFrame > 30*60
    duration = 30 * 60;
else
    duration = vidObj.NumberOfFrame;
end
video = zeros(NUM_HEIGHT, NUM_WIDTH, 3, size([1:5:duration],2) ,'single');
size([1:5:duration],2)
for i = 1 : 5 : duration
    tmp = read(vidObj,i);
    video(:,:,:,(i-1)/5+1) = imresize(tmp, [NUM_HEIGHT, NUM_WIDTH], 'bilinear');
end

d = load('ilsvrc_2012_mean');
IMAGE_MEAN = d.image_mean;
IMAGE_MEAN = imresize(IMAGE_MEAN,[NUM_HEIGHT,NUM_WIDTH]);
video = video(:,:,[3,2,1],:);
video = bsxfun(@minus,video,IMAGE_MEAN);
video = permute(video,[2,1,3,4]);

batch_size = 3;
num_images = size(video,4);
num_batches = ceil(num_images/batch_size);
FCNNFeature = [];

images = zeros(NUM_WIDTH, NUM_HEIGHT, 3, batch_size, 'single');
for bb = 1 : num_batches
    range = 1 + batch_size*(bb-1): min(num_images,batch_size*bb);
    tmp = video(:,:,:,range);
    images(:,:,:,1:size(tmp,4)) = tmp;
    size(images)
    feature = net.forward({images});
%     feature = caffe('forward',{images});
    feature = permute(feature{1},[2,1,3,4]);
    if isempty(FCNNFeature)
        FCNNFeature = zeros(size(feature,1), size(feature,2), size(feature,3), num_images, 'single');
    end
    FCNNFeature(:,:,:,range) = feature(:,:,:,mod(range-1,batch_size)+1);
end

end