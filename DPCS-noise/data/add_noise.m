% 2019-01-14
% 给数据集添加噪声，并保存

clear
clc

% data_name = 'Aggregation';
% data_name = 'D31';
% data_name = 'flame';
% data_name = 'R15';
% data_name = 's1';
data_name = 'spiral';


% 读取数据
data = load(data_name);
attribute = data.attribute;
label = data.label;

% 产生高斯随机数 mu = 0, sigma = 1
[n,m] = size(attribute);
mu = 0;
sigma = 0.5;
noise = normrnd(mu,sigma,[n,m]);
% 将大于 1 的值设置为 1，将小于 -1 的值设置为 -1
flag = noise > sigma;
noise(flag) = sigma;
flag = noise < -sigma;
noise(flag) = -sigma;

% 添加噪声
attribute = attribute + noise;

% 保存
save([data_name,'_noise.mat'],'attribute','label');