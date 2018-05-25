function value = Fmeasure(RealLabel,PredictLabel,beta)
% �������д�� 2016��12��8��
% ʵ�־������۵� Rand Index
% �ο��ʼǣ���������. NoteExpress

% RealLabel ���ݼ�ʵ�ʴر�ǩ��������
% PredictLabel ���ݼ�����ر�ǩ,������
% beta F-measure ��ƽ�����ӣ�Ĭ��Ϊ 1

if nargin == 2
    beta = 1.0;
else
    error('parameter error!');
end

n = length(RealLabel);
a = 0;
b = 0;
c = 0;
for i=1:n-1
    for j=i+1:n
        UT = RealLabel(i) == RealLabel(j);   % ʵ���У�i,j ������ͬ��
        VT = PredictLabel(i) == PredictLabel(j); % Ԥ���У�i,j ������ͬ��
        a = a+min(UT,VT);
        b = b+min(UT,~VT);
        c = c+min(~UT,VT);
    end
end

P = a/(a+b);
R = a/(a+c);
value = (beta^2+1.0)*P*R/(beta^2*P+R);

end

