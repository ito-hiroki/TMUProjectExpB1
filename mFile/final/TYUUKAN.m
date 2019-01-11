clc
clear
%% DB�̎���
c = 20; % �N���X����
n = 10; % 1�N���X������̊w�K�p�^�[����

% DB�̉摜�t�@�C���ꏊ
path = 'M:\project\dataset2\DB\jpeg\';
path2= 'M:\project\dataset2\DB\canny\';

%H = fspecial('disk', 20); %�t�B���^�[�̍쐬(�ڂ���)
for i=1:c
    for j=1:n
        str = strcat(path, num2str(n*(i-1)+j-1, '%03d'), '.jpg');
        img = imread(str);
       % img = imresize(img,[64 NaN]);
       % img = edge(img, 'Canny',[],2);
       %img = imfilter(img, H, 'replicate');
       %saveFile = strcat(path2, num2str(n*(i-1)+j-1, '%03d'), '.jpg');
       %imwrite(img, saveFile);
        DB(:,:,n*(i-1)+j) = img; % 3�����z��̏ꍇ
    end
end

%�N�G����DB
%�N�G��DB�̉摜�ꏊ
Qpath = 'M:\project\dataset2\Query\jpeg\*.jpg';
path =  'M:\project\dataset2\Query\jpeg\';
path2 = 'M:\project\dataset2\Query\canny\';
%Qpath�̒��g
D = dir(Qpath);

for i=1:length(D)
    name = strcat(path, D(i).name);
    img = imread(name);
    csvwrite('test.csv',img);
    
   % img = imresize(img,[64 NaN]);
    img = edge(img, 'Canny',[],2);

   %saveFile = strcat(path2, D(i).name);
   %imwrite(img, saveFile);
   %img = imfilter(img, H, 'replicate');
    
    Query(:,:,i) = img;
end

%% �g�p����@�\�I��
fprintf('�ǂ̃A���S���Y�����g�p���܂���?\n')
prompt = '1=�s�N�Z���}�b�`���O,2=DCT�}�b�`���O,3=KNN(hist),4=KNN(dct),5=KNN(face_parts),6=KNN(HOG),7=�������(face_parts),8=�������(dct),9=�������(HOG)\n';
hanbetu = input(prompt);
%% �s�N�Z���}�b�`���O(���x50%[canny�Ȃ�,�t�B���^�[�Ȃ�])
if(hanbetu == 1)
for i=1:length(D)
    answer(i) = matching(DB,Query,i);
end
end
%% DCT�}�b�`���O (����g����1:15�Ő��x52%,�G�b�W���o�K�p�Ő��x83%[canny����,�t�B���^�[�Ȃ�])
if(hanbetu == 2)
  for i=1:58
        img = Query(:,:,i);
        img4 = dct2(double(img));
        imgdctlow = img4(1:15,1:15);
        %newimg4 = reshape(imgdctlow, [1, 15*15]);
        %UPP(i,:)=newimg4;
        DCT_DB(:,:,i)=imgdctlow ;
end
    %csvwrite('canny_dct15_Query.csv',UPP)
    tenpest=0;
for i=1:length(D)
        [answer(i),rjflag] = dct_matching(DCT_DB,Query,i);
        tenpest=tenpest+rjflag;
end
end
%% KNN
if(hanbetu >= 3 && hanbetu <=6)

%knn���f���̍쐬
[fDB, C] = labeling(DB,hanbetu); %�����ʂ̃��x�����O
model = fitcknn(fDB, C);
model.NumNeighbors = 5; 

%knn���f���ɂ���
if(hanbetu == 5)
        Query_filename ='M:\project\dataset4\Query\csv\QFP.csv';
        Query_feature = csvread(Query_filename);
end

for i=1:length(D)
    testImg = Query(:,:,i); %�N�G���̎擾
    
    if(hanbetu == 3)
        dctF = funcDCT(testImg);
        answer(i) = predict(model, dctF);
    elseif(hanbetu == 4)
        histF = funcHIST(testImg);
        answer(i) = predict(model, histF);
    elseif(hanbetu == 5)
        faceF = Query_feature(i,:);
        answer(i) = predict(model, faceF);
    elseif(hanbetu == 6)
        hogF = funcHOG(testImg);
        answer(i) = predict(model, hogF);
    end

end
     end


%% �������(��̃p�[�c������ʂƂ��Ĉ����ꍇ)
if(hanbetu==7)
 %DB����
    DB_filename='M:\project\dataset4\DB\csv\FP.csv';
    db_feature_list = csvread(DB_filename); 
    feature_num=20;
    
 %�N�G������%
    Query_filename ='M:\project\dataset4\Query\csv\QFP.csv';
    Query_feature = csvread(Query_filename);
   %�N�G���̃T�C�Y�v�Z
    for i=1:58
        Query_feature(i,feature_num+1)=sqrt(sumsqr(Query_feature(i,:)));
    end
end
%% �������(DCT������ʂƂ���ꍇ)
if(hanbetu==8)
 %DB����
    for i=1:200
        img = DB(:,:,i);
        db_feature_list(i,:)=funcDCT(img);
    end
    feature_num=25;
   
 %�N�G������
    for i=1:58
    img = Query(:,:,i);
    Query_feature(i,:)=funcDCT(img);
    end
for i=1:58
    Query_feature(i,feature_num+1)=sqrt(sumsqr(Query_feature(i,:)));
end
end
%% �������(HOG������ʂƂ���ꍇ)
if(hanbetu==9)
        for i=1:200
        img = DB(:,:,i);
        db_feature_list(i,:)=funcHOG(img);
    end
    feature_num=2916;
     %�N�G������
    for i=1:58
    img = Query(:,:,i);
    Query_feature(i,:)=funcHOG(img);
    end
for i=1:58
    Query_feature(i,feature_num+1)=sqrt(sumsqr(Query_feature(i,:)));
end
end
%% ������ԉ񓚕�
if(hanbetu >= 7 && hanbetu <=9)
      %���ϒl�v�Z
    sub_space=zeros(20,feature_num+1);
    for i=1:20 %i=�l��
        for j=1:10 % i�l�ڂɂ���10��������
            for k=1:feature_num %�����ʂ�20��
                test(j,k)=db_feature_list((i-1)*10+j,k);
            end
        end
        %���ϒl���Ƃ�
        M=mean(test);
        for k=1:feature_num
        sub_space(i,k)=M(k);
        end
        zettai=sqrt(sumsqr(sub_space(i,:)));
        sub_space(i,feature_num+1)=zettai;
    end
    
hairetu=zeros(58,20);
    for j=1:58
    for i=1:20
        for k=1:feature_num
        hairetu(j,i)=hairetu(j,i)+Query_feature(j,k)*sub_space(i,k);
        end
        hairetu(j,i)=acos(hairetu(j,i)/(Query_feature(j,feature_num+1)*sub_space(i,feature_num+1)));
    end
    end
    [S,answer] = min(hairetu,[],2);
for i=1:58
    answer(i)=answer(i)-1;
end

end
%% Answer check

% Q���x���̍쐬
A = zeros(1, 8);
Qlabels = A;
nums = [3, 3, 4, 3, 3, 4, 2, 3, 3, 3, 3, 3, 3, 2, 1, 1, 1, 1, 2, 2];
for i=1:20
    A = ones(1, nums(i) ) * i;
    Qlabels = horzcat(Qlabels, A);
end

% ���𗦂̔���
correctNum = 0;
for i=1:length(D)
    if(answer(i) == Qlabels(i))
        correctNum = correctNum + 1;
    end
end

sprintf('����: %.3f', correctNum / ( length(D) ) )
%%
