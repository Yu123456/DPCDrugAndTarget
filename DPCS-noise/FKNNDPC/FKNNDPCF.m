function [cl, icl, time]=FKNNDPCF(dist,K)
% 2017��8��22��
% FKNN-DPC ���ຯ��
% Juanying Xie, et al. Robust clustering by detecting density peaks and
% assigning points based on fuzzy weighted K-nearest neighbors. Information
% Sciences. 2016, 354:19-40.

% Note:
%   ���������ط��漰 K-nearest neighbors, ��������ͬ�� K ֵ

% dist �����������
% K    �������

% ����ֵ
% cl   �����������ر��
% icl  ���ĵ�����Ӧ�����ݱ��, icl(2) = k  ˵���� 2 ���ص����ĵ���Ϊ k
% time  ����ʱ��

tic;         % ��һ�μ�ʱ��ʼ

[N,~] = size(dist);       % ��������

% ����ֲ��ܶ�
rho = FKNNDensity(dist,K);    % �ֲ��ܶȷ��� 

% �� rho �Ӵ�С����
% rho_sorted ������������
% ordrho ������� rho_sorted ������Ԫ���� rho �еı��
[~,ordrho]=sort(rho,'descend');
% maxd Ϊ�ܶ����ֵ���������
maxd=max(dist(ordrho(1),:));
% ��С������� delta 
delta = zeros(N,1);
% delta(ordrho(1))=-1.;
% nneigh ���Ǿ�������ĵ�ı��
nneigh = zeros(N,1);
% nneigh(ordrho(1))=0;

% ���� delta ֵ�Ĺ���
% �ҵ����Լ��ܶȴ�ĵ��о����Լ�����ĵ�
% ��¼������ nneigh �У���¼������ delta ��
for ii = 2:N
    [value, jj] =min(dist(ordrho(ii),ordrho(1:ii-1)));
    delta(ordrho(ii)) = value;
    nneigh(ordrho(ii)) = ordrho(jj);
end

% �ܶ����� delta Ϊ delta �����ֵ��
% �����ж���Ϊ�ܶ����ĵ�� delta Ϊ������Զ��֮��ľ���
% ��Ϊ�ܶ����ĵ���֮��Զ�ľ���ĵ�϶����ڵ��� delta �����ֵ
% ���������˼���������� max ����������������Ļ���������㸴�Ӷ���ͬ��
% delta(ordrho(1))=max(delta(:));
delta(ordrho(1))=maxd;


% ��һ����ͼ--����ͼ
fig_cluster = figure;
% ���� rho, delta ͼ������ȡͼ���� tt
% o ��ʾ������ɢ��
% MarkerSize ��ʶ����С
% MarkerFaceColor ��ʶ�������ɫ, k ��ʾ��ɫ
% MarkerEdgeColor ��ʶ����Ե��ɫ, k ��ʾ��ɫ
tt=plot(rho(:),delta(:),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k');
xlabel ('\rho');
ylabel ('\delta');

t1 = toc;       % ��һ������ʱ�����

% �ڵ�һ��ͼ�л�ȡ��������
% rect һ���ĸ���ֵ
% �ֱ�Ϊ xmin ymin width height
rect = getrect(fig_cluster);

tic;        % �ڶ��μ�ʱ��ʼ

% x ��Ϊ rho, ����Ϊ��������� rho ��Сֵ
rhomin=rect(1);
% ���ĸ�����Ϊ�߶�
% ���������ڴ��������Ѿ���ʾ���Ǹ�����
% �������˸����Ĵ���
% deltamin = rect(4) �޸�Ϊ deltamin = rect(2)
deltamin=rect(2);
% ��������
NCLUST=0;
% ��ʼ�� cl ����Ϊ -1
% cl Ϊ������־���飬cl(i) = j ��ʾ�� i �����ݵ�����ڵ� j �� cluster
cl = -ones(1,N);
% ͳ�����ݵ� rho �� delta ֵ��������Сֵ�ĵ�
% Ҳ����Ȧ���ο򣬰Ѿ��ε���߽���±߽���Ϊ��һ���ָ�߽�
% �ҵ�����Ҫ��ĵ�
% �ҵ�һ����˵���ҵ�һ����������
% �� cl(i) ��ֵ���Ǵ������ı�ţ��ڼ������ࣩ
% cl �ĺ������ i �������ĸ���
% icl ��¼���� nclust ��������ĵ���Ϊ i
for i=1:N
    if ( (rho(i)>rhomin) && (delta(i)>deltamin))
        NCLUST=NCLUST+1;
        cl(i)=NCLUST;     % �� i �����ݵ����ڵ� NCLUST �� cluster
        icl(NCLUST)=i;    % ��ӳ�䣬�� NCLUST �� cluster ������Ϊ�� i �����ݵ�
    end
end

% ��ȡ��ǰͼ�ε���ɫ��
% ���ص���һ�� 64*3 �ľ���ȱʡֵ�����
cmap=colormap;
figure(fig_cluster);
for i=1:NCLUST
    % ic Ϊ��ɫ����
    % ѡ�� 64 ��ĳһ�У�Ҳ����˵ֻ�ܻ��� 64 ���಻ͬ��ɫ��
    ic=int8((i*64.)/(NCLUST*1.));
    %subplot(2,1,1)
    hold on
    plot(rho(icl(i)),delta(icl(i)),'o','MarkerSize',5,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
end
title(['Decision Graph, clusters : ',num2str(NCLUST)],'FontSize',15.0);
hold off

% find outliers using Eq.(8)
% OutlierLabel ��� outlier �㣬0 ������ outlier, ����Ϊ 1�� ��ʾΪ outlier
OutlierLabel = FKNNOutliers(dist,K);

% ���淴��ʹ�� KNN ������ͳһ���� KNN ֵ����������
[KNNdis, KNNA] = sort(dist,2,'ascend');
KNNdis = KNNdis(:,2:K+1);
KNN = KNNA(:,2:K+1);


%assignation
% strategy 1
% �ر�ע�⣬�Ӵ˴���ʼ��cl ��δ��Ǵر�ŵĵ㣬��ֵΪ 0�� ������ cl ��ʼ�����е� -1
cl = AssignStrategy1(icl,dist,OutlierLabel,K);
% strategy 2
cl = AssignStrategy2(cl,icl,K,KNN,KNNdis);
% strategy 3, group the unassigned points to the cluster of its nearest
% neighbor which has been assigned
cl = AssignStrategy3(cl,KNNA);

t2 = toc;     % �ڶ��μ�ʱ����
time = t1 + t2;
 
end

