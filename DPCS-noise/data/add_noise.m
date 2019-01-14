% 2019-01-14
% �����ݼ����������������

clear
clc

% data_name = 'Aggregation';
% data_name = 'D31';
% data_name = 'flame';
% data_name = 'R15';
% data_name = 's1';
data_name = 'spiral';


% ��ȡ����
data = load(data_name);
attribute = data.attribute;
label = data.label;

% ������˹����� mu = 0, sigma = 1
[n,m] = size(attribute);
mu = 0;
sigma = 0.5;
noise = normrnd(mu,sigma,[n,m]);
% ������ 1 ��ֵ����Ϊ 1����С�� -1 ��ֵ����Ϊ -1
flag = noise > sigma;
noise(flag) = sigma;
flag = noise < -sigma;
noise(flag) = -sigma;

% �������
attribute = attribute + noise;

% ����
save([data_name,'_noise.mat'],'attribute','label');