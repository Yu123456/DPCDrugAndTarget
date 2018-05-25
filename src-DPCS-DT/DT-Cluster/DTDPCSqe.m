% 2017 �� 11 �� 3 ��
% �� DPCSeq ���� 4 ��ҩ�����ݼ�����������ͼ��ÿ����������
% ���þ��ຯ�� DPCSeqF


clear all
close all
clc
disp('DPC Clustering Drug Target data ser based on sequence running ...');
disp('The only input needed is a object file')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��������ļ���
addpath('C:\Users\Yu Donghua\Documents\MATLAB\DrugTargetPrediction\DTData');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % object name
% objName = 'CsimmatGPCR';
% datamat = load([objName,'.mat']);
% xx = datamat.matrix;
% % �Գƴ���
% xx = (xx + xx')/2;
% xx = 1-xx;         % �����ƶȾ���ת���ɾ������
% xx = libsvmscale(xx,0,1);  % ���ݹ�һ��
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С

% % object name
% objName = 'TsimmatGPCR';
% datamat = load([objName,'.mat']);
% xx = datamat.matrix;
% % �Գƴ���
% xx = (xx + xx')/2;
% xx = 1-xx;         % �����ƶȾ���ת���ɾ������
% xx = libsvmscale(xx,0,1);  % ���ݹ�һ��
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С

% % object name
% objName = 'CsimmatEnzyme';
% datamat = load([objName,'.mat']);
% xx = datamat.matrix;
% % �Գƴ���
% xx = (xx + xx')/2;
% xx = 1-xx;         % �����ƶȾ���ת���ɾ������
% xx = libsvmscale(xx,0,1);  % ���ݹ�һ��
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С

% % object name
% objName = 'TsimmatEnzyme';
% datamat = load([objName,'.mat']);
% xx = datamat.matrix;
% % �Գƴ���
% xx = (xx + xx')/2;
% xx = 1-xx;         % �����ƶȾ���ת���ɾ������
% xx = libsvmscale(xx,0,1);  % ���ݹ�һ��
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С

% % object name
% objName = 'CsimmatIonChannel';
% datamat = load([objName,'.mat']);
% xx = datamat.matrix;
% % �Գƴ���
% xx = (xx + xx')/2;
% xx = 1-xx;         % �����ƶȾ���ת���ɾ������
% xx = libsvmscale(xx,0,1);  % ���ݹ�һ��
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С

% % object name
% objName = 'TsimmatIonChannel';
% datamat = load([objName,'.mat']);
% xx = datamat.matrix;
% % �Գƴ���
% xx = (xx + xx')/2;
% xx = 1-xx;         % �����ƶȾ���ת���ɾ������
% xx = libsvmscale(xx,0,1);  % ���ݹ�һ��
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С

% % object name
% objName = 'CsimmatNuclearRecept';
% datamat = load([objName,'.mat']);
% xx = datamat.matrix;
% % �Գƴ���
% xx = (xx + xx')/2;
% xx = 1-xx;         % �����ƶȾ���ת���ɾ������
% xx = libsvmscale(xx,0,1);  % ���ݹ�һ��
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  ���ݼ���С

% object name
objName = 'TsimmatNuclearRecept';
datamat = load([objName,'.mat']);
xx = datamat.matrix;
% �Գƴ���
xx = (xx + xx')/2;
xx = 1-xx;         % �����ƶȾ���ת���ɾ������
xx = libsvmscale(xx,0,1);  % ���ݹ�һ��
dist = pdist2(xx,xx);
[ND, NL] = size(dist);  % ND = NL  ���ݼ���С





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['data set : ',objName]);
% DPCSeq ����
[cl,icl]=DPCSeqF(dist);

% ͳ��ÿ����������
K = length(icl);
cln = zeros(K,1);
for i=1:K
    flag = cl == i;
    cln(i) = sum(flag);
    disp(['�� ',num2str(i),' ��������������',num2str(cln(i))]);
end

% ������
save([objName,'Result.mat'],'cl','icl','cln');

% ���ƶ�άͼ
% ������� 2 ά���ݣ�����Ҫ���з������߶ȱ仯
% mdscale �Ƿ������߶ȱ仯�� Non-metric Multi-Dimensional Scaling��
% mdscale ֱ��չ�����ݲ����ͨ����ά�����ָ�ά����
% ʹ�� mdscale ����ִ�зǾ����ά�ȳ߶ȱ任����Ҫָ������ά�����ؽ�������õ�
% ������mdscale �ĵڶ��������һ������������õ�ֵ����������������õľ�����
% ԭʼ��������Ե��Ǻϳ̶�
Y1 = mdscale(dist, 2, 'criterion','strain');
    
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
    % �������ĵ�
    plot(Y1(icl(i),1),Y1(icl(i),2),'s','MarkerSize',10,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
end
hold off

disp(['clusters number : ',num2str(length(icl))]);
disp('running over!');