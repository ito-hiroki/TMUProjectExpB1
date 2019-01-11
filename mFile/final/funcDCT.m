function dctFeature = funcDCT(img)
   % DCT������
   img4 = dct2(double(img)); %2����DCT
   imgdctlow = img4(1:15, 1:15); %����g�����̔����o��
   newimg4 = reshape(imgdctlow, [1, 15*15]); %1������
   dctFeature = log(abs(newimg4));
end
