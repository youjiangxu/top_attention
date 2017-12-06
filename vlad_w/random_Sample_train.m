% clear
% clc
% UCF101_TDD_Root = '/home/lyb/ZSC/TDD_code/TDD-master/ucf_tddfeat/spatial1';
function random_Sample_train(UCF101_TDD_Root,splitnum)

    trainlist=importdata(['./ucfTrainTestlist/trainlist0',num2str(splitnum),'.txt']);
	
	used_list = 1:4:length(trainlist.textdata);
    sallddSample=zeros(length(used_list)*120,2048);
	current_index = 0;
	
	
    for i=1:4:length(trainlist.textdata)
        load([UCF101_TDD_Root,'/',trainlist.textdata{i}(1:end-4),'.mat'])
%         tdd=tdd_feature_spatial_1;
%         tdd=lcdspm_feature;
%         tdd=ldd_feature;
        tdd=tw_ldd_feature;
        if(size(tdd,2)<120)
            samp=tdd';
            %sallddSample=[sallddSample;samp];
			sallddSample(current_index+1:current_index+size(samp,1),:)=samp;
			current_index=current_index+size(samp,1)
        else
            index = randperm(size(tdd,2));  %%%  random sample the data for random kmeans initialization
            samp = tdd(:,index(1:120))';
            %sallddSample=[sallddSample;samp];
			sallddSample(current_index+1:current_index+size(samp,1),:)=samp;
			current_index=current_index+size(samp,1)
        end
    end
	
	
	sallddSample=sallddSample(1:current_index,:);
	
	
    mkdir ucf_Sample/;
    save(['./ucf_Sample/ucf_tddSample',num2str(splitnum),'.mat'],'sallddSample','-v7.3');    
    clear sallddSample;
end


