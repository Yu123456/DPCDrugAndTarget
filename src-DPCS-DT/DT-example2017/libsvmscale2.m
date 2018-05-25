function [sdata,model]=libsvmscale2(data)
% ʵ�� libsvm �еĹ�һ������
% ��ʹ�õĹ��� y= x / MaxValue
% x��yΪת��ǰ�����ֵ��MaxValue��MinValue�ֱ�Ϊ����ÿһ�����ֵ����Сֵ

% ����
%  data:  ���ݣ�һ��һ��������
%  lower: ��һ������
%  upper: ��һ������

% ���ز���
%   sdata: ��һ���������
%   model: ��һ��ģ���еĲ������Ա���Լ�����ֱ�ӽ��й�һ��

cmax = max(data);   % ���ֵ
cmin = min(data);   % ��Сֵ
[m,n]=size(data);   % ���������������� m������������ά����n
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

