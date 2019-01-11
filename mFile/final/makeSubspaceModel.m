% function makeSubspaceModel(DB, Query)
    faceClass = 20;
    number = 10;
    r=30;

    %DB�̍쐬
    for i=1:faceClass
        for j=1:number
            normDB(:,:,j,i) = double(DB(:,:,number*(i-1)+j))./norm(double(DB(:,:,number*(i-1)+j)));
            [picX, picY] = size(DB(:,:,number*(i-1)+j));
            for k=1:picY
                for l=1:picX
                    arrangedDB(k*picY+picX,(i-1)+j) = normDB(picY,picX,j,i);
                end
            end
        end
    end
    
    %�e�N���X�ŕ�����Ԃ����߂�
    [picX, picY] = size(DB(:,:,1));
    W = zeros(picX*picY,100,faceClass);
    for i=1:faceClass
        X = zeros(picX*picY, 1);
        for j=1:number
            X = vertcat(X,arrangedDB(:,(i-1)+j)) %�s��̗�����̘A��
        end
        C = X*X.'; %���ȑ��֍s����v�Z
        % eigenvalues ​�?and eigenvectors of C
        [eig_vec, eig_val] = eig(C); %�ŗL�x�N�g���A�ŗL�l���v�Z
        [value index] = sort(-diag(eig_val)); %�ŗL�l�̃\�[�g
        W(:,:,j+1) = eig_vec(:,index(1:100)); %�ŗL�l�̑傫�����100�{�ɑΉ�����ŗL�x�N�g�����i�[
        fprintf('Face Class %d ... OK\n',i);
    end

    %Query��DB�̍쐬
    querySize = size(Query)
    for j=1:querySize(3)
        normQuery(:,:,j,i) = double(Query(:,:,j))./norm(double(Query(:,:,j)));
        [picX, picY] = size(Query(:,:,j));
        for k=1:picY
            for l=1:picX
                arrangedQuery(k*picY+picX,j) = normDB(picY,picX,j);
            end
        end
    end

    for i = 1 : querySize(3)
        for j = 0 : 9, S(j+1)=sum((transpose(W(:,1:r,j+1))*arrangedQuery(:,i)).^2);, end %������Ԗ@�ɂ��v�Z
        [value index]=max(S);%�e��̍ő�l(value)�Ƃ��ꂪ����s(index)
        CONF(test_label(i)+1,index)=CONF(test_label(i)+1,index)+1;
        fprintf('test data %d\n',i);
    end
    accuracy=(sum(diag(CONF))./test_num).*100;
    fprintf('accuracy=%3.2f\n',accuracy);
%end