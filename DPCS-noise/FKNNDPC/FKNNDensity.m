function rho=FKNNDensity(dist, K)
% 2017��8��22��
% FJNN-DPC ��˹�˾ֲ��ܶȺ���

% dist  �������
% K     �������

% ����ֵ
% rho   �ֲ��ܶ�

% rho  �����ܶȣ���������������Ŷ�Ӧ�� dist ����

[ND, ~] = size(dist);
rho = zeros( ND,1 );       % �ֲ��ܶ�
for i=1:ND
    [~, ord] = sort(dist(i,:),'ascend');
    rho(i) = sum(exp(-dist(i,ord(2:K+1))));
end

end
