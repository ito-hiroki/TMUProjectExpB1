function hogFeature = funcHOG(img)
   % DCT������
[hogFeature, vis8x8] = extractHOGFeatures(img,'CellSize',[16 16]);
end
