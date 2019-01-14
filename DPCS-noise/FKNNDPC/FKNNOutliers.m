function outlierLabel = FKNNOutliers(dist,K)
% �������д�� 2017 �� 8 �� 22 ��
% ���� FKNN-DPC �е� outliers

% dist  �������
% K     �������

% �����
%  outlierLabel  ����Ƿ�Ϊ outlier �� 0/1 ����, �� outlier ���Ϊ 1

[N,~] = size(dist);
delta = zeros(N,1);
outlierLabel = zeros(N,1);    
for i=1:N
    [~,ord] = sort(dist(i,:),'ascend');     % ��������
    delta(i) = max(dist(i,ord(2:K+1)));
end

tao = mean(delta);   % ��ֵ
% ȷ�� outlier ��
for i=1:N
    if delta(i) > tao
        % outlier ��
        outlierLabel(i) = 1;
    end
end

end

