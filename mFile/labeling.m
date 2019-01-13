function [fDB,C]=labeling(DB,hanbetu)
    %�����ʂ�DB�쐬�֐�

   if(hanbetu==5)
             DB_filename='M:\project\dataset4\DB\csv\FP.csv';
             feature_list = csvread(DB_filename); 
   end

    for i=1:200
         %DB��i���ڂ�ǂݍ���
         img = DB(:,:,i);
         
         %i���ڂ̓����ʌv�Z
         if(hanbetu == 3)
             feature = funcDCT(img); %dct�̏ꍇ
         elseif(hanbetu == 4)
             feature = funcHIST(img); %hist�̏ꍇ
         elseif(hanbetu == 5)
             feature = feature_list(i,:);
         elseif(hanbetu == 6)
             feature = funcHOG(img);
         end
         
         %�����ʂ�DB
         fDB(:,i) = feature;
         
         %�������x��
         C(i) = fix((i-1)/10);
    end
    
    %�s�Ɨ�̓���ւ�
    C = transpose(C);
    fDB = transpose(fDB);
end

