function rho = ObjectDensity3example2017(dist)
% 2017年 3 月 29 日
% 计算样本密度
% 取一个能够包含所有对象的距离下界 dmax
% 将 dmax 等分到每一个点上，构成一个截断距离序列

% dist 距离矩阵
% rho  样本密度，列向量，样本编号对应着 dist 的列

% 密度阈值序列
[ND, ~] = size(dist);

rowMax = max(dist);
dmax = min(rowMax);
h = dmax/ND;              % 等分步长
rho_d = h:h:dmax;         % 截断距离序列
disp('截断距离序列：');
disp(rho_d);

n = length(rho_d);
rho = zeros(ND,1);
for i=1:n
    s_rho = sum( dist < rho_d(i),2) - 1; % 此处减 1 是为了删除距离矩阵中的自身与自身的距离 0.0
                                          % 密度序列不包含自身
    s_rho = libsvmscale2(s_rho);
    rho = rho + s_rho./i;
end


end