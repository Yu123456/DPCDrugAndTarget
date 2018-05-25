% 2017 年 11 月 3 日
% 用 DPCSeq 聚类 4 个药靶数据集，给出决策图及每个类样本数
% 调用聚类函数 DPCSeqF


clear all
close all
clc
disp('DPC Clustering Drug Target data ser based on sequence running ...');
disp('The only input needed is a object file')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 添加数据文件夹
addpath('C:\Users\Yu Donghua\Documents\MATLAB\DrugTargetPrediction\DTData');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % object name
% objName = 'CsimmatGPCR';
% datamat = load([objName,'.mat']);
% xx = datamat.matrix;
% % 对称处理
% xx = (xx + xx')/2;
% xx = 1-xx;         % 将相似度矩阵转换成距离矩阵
% xx = libsvmscale(xx,0,1);  % 数据归一化
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  数据集大小

% % object name
% objName = 'TsimmatGPCR';
% datamat = load([objName,'.mat']);
% xx = datamat.matrix;
% % 对称处理
% xx = (xx + xx')/2;
% xx = 1-xx;         % 将相似度矩阵转换成距离矩阵
% xx = libsvmscale(xx,0,1);  % 数据归一化
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  数据集大小

% % object name
% objName = 'CsimmatEnzyme';
% datamat = load([objName,'.mat']);
% xx = datamat.matrix;
% % 对称处理
% xx = (xx + xx')/2;
% xx = 1-xx;         % 将相似度矩阵转换成距离矩阵
% xx = libsvmscale(xx,0,1);  % 数据归一化
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  数据集大小

% % object name
% objName = 'TsimmatEnzyme';
% datamat = load([objName,'.mat']);
% xx = datamat.matrix;
% % 对称处理
% xx = (xx + xx')/2;
% xx = 1-xx;         % 将相似度矩阵转换成距离矩阵
% xx = libsvmscale(xx,0,1);  % 数据归一化
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  数据集大小

% % object name
% objName = 'CsimmatIonChannel';
% datamat = load([objName,'.mat']);
% xx = datamat.matrix;
% % 对称处理
% xx = (xx + xx')/2;
% xx = 1-xx;         % 将相似度矩阵转换成距离矩阵
% xx = libsvmscale(xx,0,1);  % 数据归一化
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  数据集大小

% % object name
% objName = 'TsimmatIonChannel';
% datamat = load([objName,'.mat']);
% xx = datamat.matrix;
% % 对称处理
% xx = (xx + xx')/2;
% xx = 1-xx;         % 将相似度矩阵转换成距离矩阵
% xx = libsvmscale(xx,0,1);  % 数据归一化
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  数据集大小

% % object name
% objName = 'CsimmatNuclearRecept';
% datamat = load([objName,'.mat']);
% xx = datamat.matrix;
% % 对称处理
% xx = (xx + xx')/2;
% xx = 1-xx;         % 将相似度矩阵转换成距离矩阵
% xx = libsvmscale(xx,0,1);  % 数据归一化
% dist = pdist2(xx,xx);
% [ND, NL] = size(dist);  % ND = NL  数据集大小

% object name
objName = 'TsimmatNuclearRecept';
datamat = load([objName,'.mat']);
xx = datamat.matrix;
% 对称处理
xx = (xx + xx')/2;
xx = 1-xx;         % 将相似度矩阵转换成距离矩阵
xx = libsvmscale(xx,0,1);  % 数据归一化
dist = pdist2(xx,xx);
[ND, NL] = size(dist);  % ND = NL  数据集大小





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['data set : ',objName]);
% DPCSeq 聚类
[cl,icl]=DPCSeqF(dist);

% 统计每个类样本数
K = length(icl);
cln = zeros(K,1);
for i=1:K
    flag = cl == i;
    cln(i) = sum(flag);
    disp(['第 ',num2str(i),' 个簇中样本数：',num2str(cln(i))]);
end

% 保存结果
save([objName,'Result.mat'],'cl','icl','cln');

% 绘制二维图
% 如果不是 2 维数据，则需要进行非量测多尺度变化
% mdscale 是非量测多尺度变化（ Non-metric Multi-Dimensional Scaling）
% mdscale 直观展现数据差异或通过降维来呈现高维数据
% 使用 mdscale 函数执行非经典多维度尺度变换，需要指定期望维数和重建输出配置的
% 方法。mdscale 的第二个输出是一个评价输出配置的值，它衡量了输出配置的距离与
% 原始输入差异性的吻合程度
Y1 = mdscale(dist, 2, 'criterion','strain');
    
% 绘制了所有的点
% 全部是黑色的点，之后再去上色
figure;
plot(Y1(:,1),Y1(:,2),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k');
title (['2D Nonclassical multidimensional scaling, clusters : ',num2str(length(icl))],'FontSize',15.0);
xlabel ('X');
ylabel ('Y');
    
NCLUST = length(icl);         % 簇个数
% 获取当前图形的颜色板
% 返回的是一个 64*3 的矩阵（缺省值情况）
cmap=colormap;
for i=1:NCLUST
    % 绘制簇
    % 用该类的颜色绘制
    nn= cl==i;
    % 对于每个簇类确定一个颜色变量 ic
    % 也就是 cmap 的某一行
    ic=int8((i*64.)/(NCLUST*1.));
    Ax = Y1(nn,1);
    Ay = Y1(nn,2);
    hold on
    plot(Ax,Ay,'o','MarkerSize',2,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
    % 绘制中心点
    plot(Y1(icl(i),1),Y1(icl(i),2),'s','MarkerSize',10,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
end
hold off

disp(['clusters number : ',num2str(length(icl))]);
disp('running over!');