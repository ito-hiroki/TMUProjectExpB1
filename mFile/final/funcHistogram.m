% �q�X�g�O���������ʂ̌��o
function histFeature = funcHistogram(img)
    % 1������
    img = img(:);
    histFeature = hist(double(img),256);
end


