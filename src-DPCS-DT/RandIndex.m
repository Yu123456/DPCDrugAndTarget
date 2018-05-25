function value = RandIndex(RealLabel,PredictLabel)
% 本程序编写于 2016年12月8日
% 实现聚类评价的 Rand Index
% 周志华. 机器学习. p198

% RealLabel 数据集实际簇标签，列向量
% PredictLabel 数据集聚类簇标签,列向量

n = length(RealLabel);
a = 0;
b = 0;
c = 0;
d = 0;
for i=1:n-1
    for j=i+1:n
        UT = RealLabel(i) == RealLabel(j);   % 实际中，i,j 属于相同簇
        VT = PredictLabel(i) == PredictLabel(j); % 预测中，i,j 属于相同簇
        a = a+min(UT,VT);       % a = | SS |
        b = b+min(~UT,VT);      % b = | SD |
        c = c+min(UT,~VT);      % c = | DS |
        d = d+min(~UT,~VT);     % d = | DD |
    end
end
value = (a+d)/(a+b+c+d);

end

