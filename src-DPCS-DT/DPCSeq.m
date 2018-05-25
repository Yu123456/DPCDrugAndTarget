% 2017��3��29��
% 1�����øĽ��ֲ��ܶȼ��㷽��  3




clear all
close all
clc
disp('DPC Clustering based on sequence running ...');
disp('The only input needed is a object file')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % object name
% objName = 'flame.txt';
% % xx Ϊ���ݵ�����
% % ���ʽΪ�����ݵ� x ����   ���ݵ� y ����  �����
% xx = load(objName);
% xx = xx(:,1:2);         % ȥ�� label
% dist = pdist2(xx,xx);
% % dist = sqrt(dist);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С


% % object name
% objName = 'R15.txt';
% % xx Ϊ���ݵ�����
% % ���ʽΪ�����ݵ� x ����   ���ݵ� y ����  �����
% xx = load(objName);
% xx = xx(:,1:2);         % ȥ�� label
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С


% % object name
% objName = 'Aggregation.txt';
% % xx Ϊ���ݵ�����
% % ���ʽΪ�����ݵ� x ����   ���ݵ� y ����  �����
% xx = load(objName);
% xx = xx(:,1:2);         % ȥ�� label
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С


% % object name
% objName = 'spiral.txt';
% % xx Ϊ���ݵ�����
% % ���ʽΪ�����ݵ� x ����   ���ݵ� y ����  �����
% xx = load(objName);
% xx = xx(:,1:2);         % ȥ�� label
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С


% object name
objName = 'example2017.mat';    % ������ֻ������Ϊ��˵���������
% xx Ϊ���ݵ�����
% ���ʽΪ�����ݵ� x ����   ���ݵ� y ����  �����
xxs = load(objName);
xx = xxs.dist;
dist = pdist2(xx,xx);
dist = sqrt(dist);
[ND, NL] = size(dist);  % ND = NL  ���ݼ���С


% % object name
% objName = 'D31.txt';
% % xx Ϊ���ݵ�����
% % ���ʽΪ�����ݵ� x ����   ���ݵ� y ����  �����
% xx = load(objName);
% xx = xx(:,1:2);         % ȥ����ǩ��
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С


% % object name
% objName = 's1.txt';
% % xx Ϊ���ݵ�����
% % ���ʽΪ�����ݵ� x ����   ���ݵ� y ����  �����
% xx = load(objName);
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['data set : ',objName]);
% DPCSeq ����
[cl,icl]=DPCSeqF(dist);

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