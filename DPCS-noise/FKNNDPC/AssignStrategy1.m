function ClassLabel = AssignStrategy1(CI,dist,outlier,K)
% �������д�� 2017 �� 8 �� 22 ��
% FKNN-DPC ��ֵ���� 1

% ���룺
% CI     �����ĵ�
% dist   �������
% outlier   outliers ����
% K      �������

% �����
% ClassLabel  ��������

[N,~] = size(dist);
ClassLabel = zeros(N,1);   % ��ֵΪ 0 ��ʾû�н������ֵ��������������������
Cluster = length(CI);      % �صĸ������������

% ���ĵ���������
for i=1:Cluster
    ClassLabel(CI(i)) = i;  % �� i �������ĵ㸳ֵΪ i
end

% ��ÿһ���ؽ��������
for i=1:Cluster
    [Que, ClassLabel] = KNNC(ClassLabel,dist,K,CI(i),outlier);
    % Que �ǿգ����Ŵ���
    while ~isempty(Que)
        [Que, ClassLabel] = KNNQue(ClassLabel,dist,K,outlier,Que);
    end
end


end

function [Q, CL] = KNNC(classlabel,dist,K,cn,outlier)
% KNN ���ֵ������ʼ������

% ����
% classlabel  �������ǣ�0 ����δ��ǵ㣬�����������
% dist        �������
% K           �������
% cn          ��һ�������ĵ���
% outlier       �쳣���ǣ����õ�Ϊ outlier ʱ�����������ֵ

% ���
% Q     ��ʼ�����У�����Ϊ��
% CL    ��������

CL = classlabel;
label = CL(cn);       % ���Ϊ cn �����ĵ�����������
[~,ord] = sort(dist(cn,:),'ascend');
% ���� K ������ڵ㣬��Ϊ dist ����������� 0�� ��˴� 2 ��ʼ����
Q = zeros(K,1);
k = 0;     % ��¼�������ֵ��ĸ���
for i=2:K+1
    num = ord(i);     % K ����ڴ��������
    % ������Ϊ num �ĵ�δ��������ţ�����д������򲻴���
%     if CL(num) == 0 && outlier(num) == 0
    if CL(num) == 0 
        k = k+1;           % ����һ���㣬����
        CL(num) = label;
        Q(k) = num;
    end
end
Q = Q(1:k);

end

function [Q, CL] = KNNQue(classlabel,dist,K,outlier,que)
% KNN ���и�ֵ��ֻ�����ͷһ����

% ����
% classlabel    ��ǰ������ǣ�0 ��ʾδ��ֵ���
% dist          �������
% K             �������
% outlier       �쳣���ǣ����õ�Ϊ outlier ʱ�����������ֵ
% que           ���У��ú���ÿ��ִ��ֻ�����ͷһ����

% ���
% Q             �����Ķ���
% CL            �����������

CL = classlabel;
p = que(1);     % ��ͷ����
Q = que(2:end); % ɾ����ͷ�ĵ�
label = CL(p);  % ���Ϊ p �ĵ�����
% p �� K-nearest neighbors
[~,ord] = sort(dist(p,:),'ascend');
KNNP = ord(2:K+1);    % p �� K-nearest neighbors ��ı��
for i=1:K
    q = KNNP(i);
    if CL(q) == 0 && outlier(q) == 0
        % q ��δ��ֵ���Ҳ���� outlier
        % ���� q �� K-nearest neighbors ��ƽ������
        [~,ordq] = sort(dist(q,:),'ascend');
        dis = mean(dist(q,ordq(2:K+1)));
        if dist(p,q) <= dis
            % ����С�� K ����ھ����ֵ
            CL(q) = label;
            % �� q �������
            Q = [Q; q];
        end
    end
end

end