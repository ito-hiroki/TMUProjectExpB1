%% knn���f���̍쐬

[fDB, C] = labeling(DB); %�����ʂ̃��x�����O
model = fitcknn(fDB, C);
model.NumNeighbors = 5; 