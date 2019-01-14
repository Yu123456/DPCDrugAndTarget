function ClassLabel = AssignStrategy2(classlabel,CI,K,KNN,KNNdis)
% �������д�� 2017 �� 8 �� 22 ��
% FKNN-DPC ��ֵ���� 2

% ���룺
% classlabel  �������ǩ��0 ��ʾδ���б�ǩ��ֵ
% CI     �����ĵ�
% K      �������
% KNN    ������������󣬶�Ӧ dist ����
% KNNdis ����ھ�����󣬶�Ӧ dist ����

% �����
% ClassLabel  ��������

% ����ܸ���
N = length(classlabel);
ClassLabel = classlabel;

% δ��������ǵĵ��� m
m = sum( ClassLabel == 0 );
if m == 0
    % ���е��Ѿ���������ǣ�ֱ���˳� strategy 2
    return;
else
    cluster = length(CI);    % �صĸ���
    A = zeros(m,cluster);    % δ����ǵ�������Ⱦ���
    VA = zeros(m,1);         % δ����ǵ��������������
    VP = zeros(m,1);         % δ�����������ȵ�����
    Nom = zeros(m,1);        % δ��ǵ��Ӧԭʼ���� classlabel �еı��
    invNom = zeros(N,1);     % ��� Nom �е�������ֵ������
    i = 0;
    for k=1:N
        if ClassLabel(k) == 0
            i = i+1;
            Nom(i) = k;      % �� k ����δ������
            invNom(k) = i;   % ԭʼ�����еĵ� k ������δ��ǵ��еĵ� i ����
            % ����� i ��δ��ǵ�����������
            A(i,:) = Membership(k,ClassLabel,cluster,K,KNN,KNNdis);
            [VA(i),VP(i)] = max(A(i,:));
        end
    end
    [bool,p] = HighestP(VA);       % p �� VA �����ֵ��Ӧ������
    while bool
        % ѡ����������ȵ� p
        ClassLabel(Nom(p)) = VP(p);    % ��ֵ p �����        
        % ���������Ⱦ��� A, �� VA, VP
        [A, VA, VP] = UpdateA(p,A,Nom,KNN,KNNdis,VA, VP);
        [bool,p] = HighestP(VA);       % p �� VA �����ֵ��Ӧ������
    end
end


end

% �������������
function val = Membership(p,classlabel,cluster,K,KNN,KNNdis)
% p    ������Ϊ p (��Ӧԭʼ���� dist �еı��)�ĵ�����������
% classlabel  �������ǣ�0 ��ʾδ��ǣ�����Ϊ�� 1 ��ʼ������
% cluster     �ظ���
% K           �������
% KNN    ������������󣬶�Ӧ dist ����
% KNNdis ����ھ�����󣬶�Ӧ dist ����

% ���
% val   �� p ����������ȣ�������

val = zeros(1,cluster);
KNNP = KNN(p,:);       % p �� K ���ڱ��
KNNpdis = KNNdis(p,:); % p �� K ���ھ���
for i=1:K
    j = KNNP(i);       % �� i ������ڵ���
    cl = classlabel(j); % ��� j ������ţ�0 ��ʾû�б��
    if cl ~= 0
        Wpj = 1/(1+KNNpdis(i));
        % ���� gamma_pj
        ds = KNNdis(j,:);
        Gpj = Wpj/sum( 1./(1+ds));
        val(cl) = val(cl) + Gpj*Wpj;
    end
end

end

% ѡ����������ȵĵ�
function [bool,p] = HighestP(VA)
% VA    �������������

bool = 0;
[val, p] = max(VA);
if val > 0
    bool = 1;
end

end

% ���������Ⱦ���
function [A, VA, VP] = UpdateA(p,pa,Nom,KNN,KNNdis,va, vp)
% p      ���µ��ţ���Ӧ�� pa
% pa     �����Ⱦ���
% Nom    δ��ǵ��Ӧԭʼ���ݵı��
% KNN    ������������󣬶�Ӧ dist ����
% KNNdis ����ھ�����󣬶�Ӧ dist ����
% va     ������������
% vp     ��������ȵ����

% ���
% A     �����Ⱦ���
% VA     ������������
% VP     ��������ȵ����

A = pa;
VA = va;
VP = vp;
[m,~] = size(A);

% ע��ԭ����д q\in KNNp Ӧ���Ǵ���ģ�
% �� p �������ֵ��
% Ӧ�޸�Ϊ�������� q, �� p\in KNNq ʱ����Ҫ�޸� p_q^c
Pn = Nom(p);
KNNpdis = KNNdis(Pn,:);
spdis = sum(1./(1+KNNpdis));
% p ���������
plabel = VP(p);
% ��ֹ����������ȵ�ѡ�񣬶����Ѿ���ֵ���� p ����Ӧ�� VA, VP ���и�ֵ
VA(p) = 0;
VP(p) = -1;
for i=1:m
    if VP(i) ~= -1
        % �� i ���㣨��Ӧ���� A �еı�ţ�δ�������ֵ�ĵ�
        [lia,loc] = ismember(Pn,KNN(Nom(i),:));
        if lia ~= 0
            % ˵�� p\in KNNq, ���� p_q^c
            Wqp = 1/(1+ KNNdis(Nom(i),loc));
            Gqp = Wqp/spdis;
            A(i,plabel) = A(i,plabel) + Gqp*Wqp;
            [VA(i),VP(i)] = max(A(i,:));
        end
    end
end




end