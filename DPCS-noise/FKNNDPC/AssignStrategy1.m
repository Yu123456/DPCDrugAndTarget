function ClassLabel = AssignStrategy1(CI,dist,outlier,K)
% 本程序编写于 2017 年 8 月 22 日
% FKNN-DPC 赋值策略 1

% 输入：
% CI     簇中心点
% dist   距离矩阵
% outlier   outliers 点标记
% K      最近邻数

% 输出：
% ClassLabel  点的类别标记

[N,~] = size(dist);
ClassLabel = zeros(N,1);   % 其值为 0 表示没有进行类别赋值，否则就是其所属的类别
Cluster = length(CI);      % 簇的个数，即类别数

% 中心点进行类别标记
for i=1:Cluster
    ClassLabel(CI(i)) = i;  % 第 i 个簇中心点赋值为 i
end

% 对每一个簇进行类别标记
for i=1:Cluster
    [Que, ClassLabel] = KNNC(ClassLabel,dist,K,CI(i),outlier);
    % Que 非空，接着处理
    while ~isempty(Que)
        [Que, ClassLabel] = KNNQue(ClassLabel,dist,K,outlier,Que);
    end
end


end

function [Q, CL] = KNNC(classlabel,dist,K,cn,outlier)
% KNN 类别赋值，并初始化队列

% 输入
% classlabel  点的类别标记，0 代表未标记点，其它代表类别
% dist        距离矩阵
% K           最近邻数
% cn          （一个）中心点编号
% outlier       异常点标记，当该点为 outlier 时，不进行类别赋值

% 输出
% Q     初始化队列，可以为空
% CL    点的类别标记

CL = classlabel;
label = CL(cn);       % 编号为 cn 的中心点所代表的类别
[~,ord] = sort(dist(cn,:),'ascend');
% 处理 K 个最近邻点，因为 dist 中有自身距离 0， 因此从 2 开始处理
Q = zeros(K,1);
k = 0;     % 记录进行类别赋值点的个数
for i=2:K+1
    num = ord(i);     % K 最近邻待处理点编号
    % 如果编号为 num 的点未进行类别编号，则进行处理，否则不处理
%     if CL(num) == 0 && outlier(num) == 0
    if CL(num) == 0 
        k = k+1;           % 处理一个点，自增
        CL(num) = label;
        Q(k) = num;
    end
end
Q = Q(1:k);

end

function [Q, CL] = KNNQue(classlabel,dist,K,outlier,que)
% KNN 队列赋值，只处理队头一个点

% 输入
% classlabel    当前点类别标记，0 表示未赋值类别
% dist          距离矩阵
% K             最近邻数
% outlier       异常点标记，当该点为 outlier 时，不进行类别赋值
% que           队列，该函数每次执行只处理队头一个点

% 输出
% Q             处理后的队列
% CL            处理后的类别标记

CL = classlabel;
p = que(1);     % 队头点编号
Q = que(2:end); % 删除队头的点
label = CL(p);  % 编号为 p 的点的类别
% p 的 K-nearest neighbors
[~,ord] = sort(dist(p,:),'ascend');
KNNP = ord(2:K+1);    % p 的 K-nearest neighbors 点的编号
for i=1:K
    q = KNNP(i);
    if CL(q) == 0 && outlier(q) == 0
        % q 既未赋值类别，也不是 outlier
        % 计算 q 的 K-nearest neighbors 的平均距离
        [~,ordq] = sort(dist(q,:),'ascend');
        dis = mean(dist(q,ordq(2:K+1)));
        if dist(p,q) <= dis
            % 距离小于 K 最近邻距离均值
            CL(q) = label;
            % 将 q 加入队列
            Q = [Q; q];
        end
    end
end

end