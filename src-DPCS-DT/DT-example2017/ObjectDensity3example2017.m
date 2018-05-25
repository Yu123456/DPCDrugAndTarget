function rho = ObjectDensity3example2017(dist)
% 2017�� 3 �� 29 ��
% ���������ܶ�
% ȡһ���ܹ��������ж���ľ����½� dmax
% �� dmax �ȷֵ�ÿһ�����ϣ�����һ���ضϾ�������

% dist �������
% rho  �����ܶȣ���������������Ŷ�Ӧ�� dist ����

% �ܶ���ֵ����
[ND, ~] = size(dist);

rowMax = max(dist);
dmax = min(rowMax);
h = dmax/ND;              % �ȷֲ���
rho_d = h:h:dmax;         % �ضϾ�������
disp('�ضϾ������У�');
disp(rho_d);

n = length(rho_d);
rho = zeros(ND,1);
for i=1:n
    s_rho = sum( dist < rho_d(i),2) - 1; % �˴��� 1 ��Ϊ��ɾ����������е�����������ľ��� 0.0
                                          % �ܶ����в���������
    s_rho = libsvmscale2(s_rho);
    rho = rho + s_rho./i;
end


end