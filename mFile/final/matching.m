function number = matching(DB,Query,q)
%�P���}�b�`���O�֐�(�֐�M�t�@�C��)
%�N�G���摜X��DB�̉摜���s�N�Z�����ɔ�r���A���덷���ł��������l�����o�͂���
X = Query(:,:,q);
dblX = double(X); 
for i=1:200
    A = DB(:,:,i);
    dblA = double(A);
    D = (dblX-dblA).^2;
    distance(i) = sum(sum(D));
end

[minimum, index] = min(distance);

number = ceil(index/10)-1;
%sprintf('X is Person %d.',number)
end

