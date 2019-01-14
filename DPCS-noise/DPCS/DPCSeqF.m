function [cl, icl]=DPCSeqF(dist)
% 2017��3��29��
% DPC ���ڽض����еľ��ຯ��

% dist �����������

% ����ֵ
% cl   �����������ر��
% icl  ���ĵ�����Ӧ�����ݱ��, icl(2) = k  ˵���� 2 ���ص����ĵ���Ϊ k

[N,~] = size(dist);       % ��������

% ����ֲ��ܶ�
% rho = ObjectDensity2(dist);    % �ֲ��ܶȷ��� 2
rho = ObjectDensity3(dist);    % �ֲ��ܶȷ��� 3
% rho = ObjectDensity4(dist);    % �ֲ��ܶȷ��� 4
% �� rho �Ӵ�С����
% rho_sorted ������������
% ordrho ������� rho_sorted ������Ԫ���� rho �еı��
[~,ordrho]=sort(rho,'descend');
% maxd Ϊ�ܶ����ֵ���������
maxd=max(dist(ordrho(1),:));
% delta �������е� \delta
% ����õġ��ضϡ���
% rho ΪС�ڽضϾ�����ھ�����Ҳ�����ܶ�
% ��ˣ������ܶ����ĵ������� delta Ϊ -1
% ���������ܶȵ�� delta ֵΪ��С�ľ���ֵ
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
% ��һ������
deltaMin = min(delta);
delta = (delta-deltaMin)/(maxd-deltaMin);

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

% �ڵ�һ��ͼ�л�ȡ��������
% rect һ���ĸ���ֵ
% �ֱ�Ϊ xmin ymin width height
rect = getrect(fig_cluster);
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
title(['Decision Graph, clusters : ',num2str(NCLUST)],'FontSize',10.0);
hold off

%assignation
for i=1:N
    % cl(i) Ϊ -1 ˵�����Ǵ�������
    % ��ô������ݵ����������ھ���������������ܶȴ�����ݵ���
    % �� rho �ĵݼ�˳�򣬱�֤�˸�ֵ������ִ���
    % ��Ϊ�Ǵ��ܶ����ĵ㿪ʼ��ֵ��
    if (cl(ordrho(i))==-1)
        cl(ordrho(i))=cl(nneigh(ordrho(i)));
    end
end
 
end

