function outlierLabel = FKNNOutliers(dist,K)
% 本程序编写于 2017 年 8 月 22 日
% 计算 FKNN-DPC 中的 outliers

% dist  距离矩阵
% K     最近邻数

% 输出：
%  outlierLabel  标记是否为 outlier 的 0/1 向量, 是 outlier 标记为 1

[N,~] = size(dist);
delta = zeros(N,1);
outlierLabel = zeros(N,1);    
for i=1:N
    [~,ord] = sort(dist(i,:),'ascend');     % 递增排序
    delta(i) = max(dist(i,ord(2:K+1)));
end

tao = mean(delta);   % 均值
% 确定 outlier 点
for i=1:N
    if delta(i) > tao
        % outlier 点
        outlierLabel(i) = 1;
    end
end

end

