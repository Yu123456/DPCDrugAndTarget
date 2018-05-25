function value = Fmeasure(RealLabel,PredictLabel,beta)
% 本程序编写于 2016年12月8日
% 实现聚类评价的 Rand Index
% 参考笔记，聚类评价. NoteExpress

% RealLabel 数据集实际簇标签，列向量
% PredictLabel 数据集聚类簇标签,列向量
% beta F-measure 的平衡因子，默认为 1

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
        UT = RealLabel(i) == RealLabel(j);   % 实际中，i,j 属于相同簇
        VT = PredictLabel(i) == PredictLabel(j); % 预测中，i,j 属于相同簇
        a = a+min(UT,VT);
        b = b+min(UT,~VT);
        c = c+min(~UT,VT);
    end
end

P = a/(a+b);
R = a/(a+c);
value = (beta^2+1.0)*P*R/(beta^2*P+R);

end

