function rho=FKNNDensity(dist, K)
% 2017年8月22日
% FJNN-DPC 高斯核局部密度函数

% dist  距离矩阵
% K     最近邻数

% 返回值
% rho   局部密度

% rho  样本密度，列向量，样本编号对应着 dist 的列

[ND, ~] = size(dist);
rho = zeros( ND,1 );       % 局部密度
for i=1:ND
    [~, ord] = sort(dist(i,:),'ascend');
    rho(i) = sum(exp(-dist(i,ord(2:K+1))));
end

end
