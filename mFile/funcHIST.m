function histFeature = funcHIST(img) 
    % DCT������
    testImg = img(:); %
    histFeature = hist(double(testImg), 256);
end

