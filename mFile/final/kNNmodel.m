% DB: DB�̓�����
% X: DB�̐������x��

function Mdl = kNNmodel(feature, label)
    
    Mdl = fitcknn(feature, label, 'NumNeighbors',5,'Standardize',1);
    
end