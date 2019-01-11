% MATLAB���DB���������邽�߂̃X�N���v�gM�t�@�C��
clc
clear
c = 20; % �N���X����
n = 10; % 1�N���X������̊w�K�p�^�[����

% DB�̉摜�t�@�C���ꏊ
path = 'M:\project\dataset2\DB\jpeg\';

%H = fspecial('disk', 20); %�t�B���^�[�̍쐬(�ڂ���)
for i=1:c
    for j=1:n
        str = strcat(path, num2str(n*(i-1)+j-1, '%03d'), '.jpg');
        img = imread(str);
       
          %img = edge(img, 'Canny');
          %img = imfilter(img, H, 'replicate');

        DB(:,:,n*(i-1)+j) = img; % 3�����z��̏ꍇ
    end
end

%% �N�G����DB
%�N�G��DB�̉摜�ꏊ
Qpath = 'M:\project\dataset2\Query\jpeg\*.jpg';
path = 'M:\project\dataset2\Query\jpeg\';

%Qpath�̒��g
D = dir(Qpath);

for i=1:length(D)
    name = strcat(path, D(i).name);
    img = imread(name);
    
    %img = edge(img, 'Canny');
    %img = imfilter(img, H, 'replicate');
    
    Query(:,:,i) = img;
end