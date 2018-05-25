function [sdata,model]=libsvmscale2(data)
% 实现 libsvm 中的归一化函数
% 所使用的规则： y= x / MaxValue
% x、y为转换前、后的值，MaxValue、MinValue分别为样本每一列最大值和最小值

% 参数
%  data:  数据（一行一个样本）
%  lower: 归一化下限
%  upper: 归一化上限

% 返回参数
%   sdata: 归一化后的数据
%   model: 归一化模型中的参数，以便测试集可以直接进行归一化

cmax = max(data);   % 最大值
cmin = min(data);   % 最小值
[m,n]=size(data);   % 行数（样本个数） m，列数（样本维数）n
sdata = zeros(m,n);
for i = 1:n
    if cmin(i) == cmax(i)
        sdata(:,i) = 0.0;
    else
        sdata(:,i) = data(:,i)/cmax(i);
    end
end

model.max = cmax;
model.min = cmin;
 
end

