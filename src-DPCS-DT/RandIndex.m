function value = RandIndex(RealLabel,PredictLabel)
% �������д�� 2016��12��8��
% ʵ�־������۵� Rand Index
% ��־��. ����ѧϰ. p198

% RealLabel ���ݼ�ʵ�ʴر�ǩ��������
% PredictLabel ���ݼ�����ر�ǩ,������

n = length(RealLabel);
a = 0;
b = 0;
c = 0;
d = 0;
for i=1:n-1
    for j=i+1:n
        UT = RealLabel(i) == RealLabel(j);   % ʵ���У�i,j ������ͬ��
        VT = PredictLabel(i) == PredictLabel(j); % Ԥ���У�i,j ������ͬ��
        a = a+min(UT,VT);       % a = | SS |
        b = b+min(~UT,VT);      % b = | SD |
        c = c+min(UT,~VT);      % c = | DS |
        d = d+min(~UT,~VT);     % d = | DD |
    end
end
value = (a+d)/(a+b+c+d);

end

