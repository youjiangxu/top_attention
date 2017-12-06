function buildTDD_train_test(splitnum,ReDim)
    disp('dim');
%     ReDim=256
    trainlist=importdata(['./ucfTrainTestlist/trainlist0',num2str(splitnum),'.txt']);
    testlist=importdata(['./ucfTrainTestlist/testlist0',num2str(splitnum),'.txt']);
    tdd_q_root=['./VLAD_kQ/UCF/c_256d_',num2str(ReDim),'/',num2str(splitnum)];

    
    train_fea=zeros(length(trainlist.textdata),256*512);
    train_lab=[];
    test_fea=zeros(length(testlist),256*512);
    test_lab=[];
    trainsum =0;
	
	for i=1:length(trainlist.textdata)
        trainlist.textdata{i}
        load([tdd_q_root,'/',trainlist.textdata{i}(1:end-4),'.mat'])
%         load([tdd_q_root,'/',trainlist.textdata{i}(1:end-4),'.mat'])
        train_fea(i,:)=Quantization';
        train_lab=[train_lab;Label];
        trainsum=trainsum+1;
    end
    mkdir (['Train_Test_Data/ucf_split',num2str(splitnum),'/'])
    save(['./Train_Test_Data/ucf_split',num2str(splitnum),'/res_trainData_twtopldddif_c256_d',num2str(ReDim),'.mat'],'train_fea','train_lab','-v7.3');
    clear train_fea;
    clear train_lab;
	
	for i=1:length(testlist)
        testlist{i}
        load([tdd_q_root,'/',testlist{i}(1:end-4),'.mat'])
%         load([tdd_q_root,'/',testlist{i}(1:end-4),'.mat'])
        test_fea(i,:)=Quantization';
        test_lab=[test_lab;Label];
    end
    save(['./Train_Test_Data/ucf_split',num2str(splitnum),'/res_testData_twtopldddif_c256_d',num2str(ReDim),'.mat'],'test_fea','test_lab','-v7.3');
    clear test_fea;
    clear test_lab;
end

