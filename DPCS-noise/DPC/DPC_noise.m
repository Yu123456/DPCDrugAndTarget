% 2019-1-14
% DPC ���ຬ�������ݼ����� ACC, AMI



clear all
close all
clc
disp('DPC Clustering based on sequence running ...');
disp('The only input needed is a object file')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��������ļ���
addpath('C:\Users\YDH\Documents\MATLAB\Cluster\DPC-YU-Seq\DPCS-noise\data');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% object name
objName = 'Aggregation_noise.mat';
% xx Ϊ���ݵ�����
% ���ʽΪ�����ݵ� x ����   ���ݵ� y ����  �����
datamat = load(objName);
xx = datamat.attribute;
label = datamat.label;     % ʵ�ʴر�ǩ
dist = pdist2(xx,xx);
[ND, NL] = size(dist);  % ND = NL  ���ݼ���С
percent = 2.0;


% % object name
% objName = 'D31_noise.mat';
% % xx Ϊ���ݵ�����
% % ���ʽΪ�����ݵ� x ����   ���ݵ� y ����  �����
% datamat = load(objName);
% xx = datamat.attribute;
% label = datamat.label;     % ʵ�ʴر�ǩ
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С
% percent = 2.0;

% % object name
% objName = 'flame_noise.mat';
% % xx Ϊ���ݵ�����
% % ���ʽΪ�����ݵ� x ����   ���ݵ� y ����  �����
% datamat = load(objName);
% xx = datamat.attribute;
% label = datamat.label;     % ʵ�ʴر�ǩ
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С
% percent = 5.0;

% % object name
% objName = 'R15_noise.mat';
% % xx Ϊ���ݵ�����
% % ���ʽΪ�����ݵ� x ����   ���ݵ� y ����  �����
% datamat = load(objName);
% xx = datamat.attribute;
% label = datamat.label;     % ʵ�ʴر�ǩ
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С
% percent = 2.0;

% % object name
% objName = 's1_noise.mat';
% % xx Ϊ���ݵ�����
% % ���ʽΪ�����ݵ� x ����   ���ݵ� y ����  �����
% datamat = load(objName);
% xx = datamat.attribute;
% label = datamat.label;     % ʵ�ʴر�ǩ
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С
% percent = 2.0;

% % object name
% objName = 'spiral_noise.mat';
% % xx Ϊ���ݵ�����
% % ���ʽΪ�����ݵ� x ����   ���ݵ� y ����  �����
% datamat = load(objName);
% xx = datamat.attribute;
% label = datamat.label;     % ʵ�ʴر�ǩ
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С
% percent = 2.0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['data set : ',objName]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����Դ�����ṩ�ĽضϾ�����㷽ʽ
% Դ���벿�ֽ���
% 1��Դ����ֱ�Ӷ�ȡ����Եľ��룬���ǲ�������������ľ��� 0
% 2��Դ�����ж�ȡ�ľ����У�ֻ������������е��ϣ��£����ǲ���
% 3������������Ϊ n, ��Դ�����е� N = n*(n-1)/2
% 4���ضϾ���ȡ��N ��ռ�ٷֱ� 2 ����������ȡ��
N = ND*(ND-1)/2.0;
sda = zeros(N,1);
k = 0;
for i=1:ND-1
    for j=i+1:ND
        k = k+1;
        sda(k) = dist(i,j);
    end
end
position = round(N*percent/100);
sda = sort(sda);
dc = sda(position);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DPC ����
[cl,icl]=DPCF(dist,dc);

% ���ֶ������۾���
disp('clustering evaluation');
ACC = ClusteringAccuracy(label,cl);
AMI = ami(label,cl);
disp([' ACC  : ',num2str(ACC)]);
disp([' AMI  : ',num2str(AMI)]);

% ���ƾ���ͼ
if length(xx(1,:)) == 2
    % ����� 2 ά���ݣ���ֱ�ӻ�������ͼ
    % Ĭ��Ϊ�� 1 ��Ϊ x ���꣬�� 2 ��Ϊ y ����
    Y1 = xx;
    % ���������еĵ�
    % ȫ���Ǻ�ɫ�ĵ㣬֮����ȥ��ɫ
    figure;
    plot(Y1(:,1),Y1(:,2),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k');
    title (['2D directly plot, clusters : ',num2str(length(icl))],'FontSize',15.0);
    xlabel ('X');
    ylabel ('Y');
    
    NCLUST = length(icl);         % �ظ���
    % ��ȡ��ǰͼ�ε���ɫ��
    % ���ص���һ�� 64*3 �ľ���ȱʡֵ�����
    cmap=colormap;
    for i=1:NCLUST
        % ���ƴ�
        % �ø������ɫ����
        nn= cl==i;
        % ����ÿ������ȷ��һ����ɫ���� ic
        % Ҳ���� cmap ��ĳһ��
        ic=int8((i*64.)/(NCLUST*1.));
        Ax = Y1(nn,1);
        Ay = Y1(nn,2);
        hold on
        plot(Ax,Ay,'o','MarkerSize',2,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
    end
    hold off
else
    % ������� 2 ά���ݣ�����Ҫ���з������߶ȱ仯
    % mdscale �Ƿ������߶ȱ仯�� Non-metric Multi-Dimensional Scaling��
    % mdscale ֱ��չ�����ݲ����ͨ����ά�����ָ�ά����
    % ʹ�� mdscale ����ִ�зǾ����ά�ȳ߶ȱ任����Ҫָ������ά�����ؽ�������õ�
    % ������mdscale �ĵڶ��������һ������������õ�ֵ����������������õľ�����
    % ԭʼ��������Ե��Ǻϳ̶�
    Y1 = mdscale(dist, 2, 'criterion','metricstress');
    
    % ���������еĵ�
    % ȫ���Ǻ�ɫ�ĵ㣬֮����ȥ��ɫ
    figure;
    plot(Y1(:,1),Y1(:,2),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k');
    title (['2D Nonclassical multidimensional scaling, clusters : ',num2str(length(icl))],'FontSize',15.0);
    xlabel ('X');
    ylabel ('Y');
    
    NCLUST = length(icl);         % �ظ���
    % ��ȡ��ǰͼ�ε���ɫ��
    % ���ص���һ�� 64*3 �ľ���ȱʡֵ�����
    cmap=colormap;
    for i=1:NCLUST
        % ���ƴ�
        % �ø������ɫ����
        nn= cl==i;
        % ����ÿ������ȷ��һ����ɫ���� ic
        % Ҳ���� cmap ��ĳһ��
        ic=int8((i*64.)/(NCLUST*1.));
        Ax = Y1(nn,1);
        Ay = Y1(nn,2);
        hold on
        plot(Ax,Ay,'o','MarkerSize',2,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
    end
    hold off
end

disp(['clusters number : ',num2str(length(icl))]);
disp('running over!');