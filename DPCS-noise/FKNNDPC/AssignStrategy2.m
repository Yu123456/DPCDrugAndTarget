function ClassLabel = AssignStrategy2(classlabel,CI,K,KNN,KNNdis)
% 本程序编写于 2017 年 8 月 22 日
% FKNN-DPC 赋值策略 2

% 输入：
% classlabel  点的类别标签，0 表示未进行标签赋值
% CI     簇中心点
% K      最近邻数
% KNN    最近邻索引矩阵，对应 dist 矩阵
% KNNdis 最近邻距离矩阵，对应 dist 矩阵

% 输出：
% ClassLabel  点的类别标记

% 点的总个数
N = length(classlabel);
ClassLabel = classlabel;

% 未进行类别标记的点数 m
m = sum( ClassLabel == 0 );
if m == 0
    % 所有点已经进行类别标记，直接退出 strategy 2
    return;
else
    cluster = length(CI);    % 簇的个数
    A = zeros(m,cluster);    % 未类别标记点的隶属度矩阵
    VA = zeros(m,1);         % 未类别标记点的类别最大隶属度
    VP = zeros(m,1);         % 未标记最大隶属度点的类别
    Nom = zeros(m,1);        % 未标记点对应原始数据 classlabel 中的编号
    invNom = zeros(N,1);     % 标记 Nom 中的索引与值得逆编号
    i = 0;
    for k=1:N
        if ClassLabel(k) == 0
            i = i+1;
            Nom(i) = k;      % 第 k 个点未标记类别
            invNom(k) = i;   % 原始数据中的第 k 个点是未标记点中的第 i 个点
            % 计算第 i 个未标记点的类别隶属度
            A(i,:) = Membership(k,ClassLabel,cluster,K,KNN,KNNdis);
            [VA(i),VP(i)] = max(A(i,:));
        end
    end
    [bool,p] = HighestP(VA);       % p 是 VA 中最大值对应的索引
    while bool
        % 选定最大隶属度点 p
        ClassLabel(Nom(p)) = VP(p);    % 赋值 p 的类别        
        % 更新隶属度矩阵 A, 及 VA, VP
        [A, VA, VP] = UpdateA(p,A,Nom,KNN,KNNdis,VA, VP);
        [bool,p] = HighestP(VA);       % p 是 VA 中最大值对应的索引
    end
end


end

% 计算类别隶属度
function val = Membership(p,classlabel,cluster,K,KNN,KNNdis)
% p    计算编号为 p (对应原始数据 dist 中的编号)的点的类别隶属度
% classlabel  点的类别标记，0 表示未标记，其它为从 1 开始的整数
% cluster     簇个数
% K           最近邻数
% KNN    最近邻索引矩阵，对应 dist 矩阵
% KNNdis 最近邻距离矩阵，对应 dist 矩阵

% 输出
% val   点 p 的类别隶属度，行向量

val = zeros(1,cluster);
KNNP = KNN(p,:);       % p 的 K 近邻编号
KNNpdis = KNNdis(p,:); % p 的 K 近邻距离
for i=1:K
    j = KNNP(i);       % 第 i 个最近邻点编号
    cl = classlabel(j); % 编号 j 的类别标号，0 表示没有标号
    if cl ~= 0
        Wpj = 1/(1+KNNpdis(i));
        % 计算 gamma_pj
        ds = KNNdis(j,:);
        Gpj = Wpj/sum( 1./(1+ds));
        val(cl) = val(cl) + Gpj*Wpj;
    end
end

end

% 选择最大隶属度的点
function [bool,p] = HighestP(VA)
% VA    类别的最大隶属度

bool = 0;
[val, p] = max(VA);
if val > 0
    bool = 1;
end

end

% 更新隶属度矩阵
function [A, VA, VP] = UpdateA(p,pa,Nom,KNN,KNNdis,va, vp)
% p      更新点编号，对应着 pa
% pa     隶属度矩阵
% Nom    未标记点对应原始数据的编号
% KNN    最近邻索引矩阵，对应 dist 矩阵
% KNNdis 最近邻距离矩阵，对应 dist 矩阵
% va     类别最大隶属度
% vp     最大隶属度的类别

% 输出
% A     隶属度矩阵
% VA     类别最大隶属度
% VP     最大隶属度的类别

A = pa;
VA = va;
VP = vp;
[m,~] = size(A);

% 注，原文中写 q\in KNNp 应该是错误的，
% 将 p 进行类别赋值后
% 应修改为对于任意 q, 当 p\in KNNq 时，需要修改 p_q^c
Pn = Nom(p);
KNNpdis = KNNdis(Pn,:);
spdis = sum(1./(1+KNNpdis));
% p 所属的类别
plabel = VP(p);
% 防止对最大隶属度的选择，对于已经赋值类别的 p 所对应的 VA, VP 进行赋值
VA(p) = 0;
VP(p) = -1;
for i=1:m
    if VP(i) ~= -1
        % 第 i 个点（对应矩阵 A 中的编号）未进行类别赋值的点
        [lia,loc] = ismember(Pn,KNN(Nom(i),:));
        if lia ~= 0
            % 说明 p\in KNNq, 调整 p_q^c
            Wqp = 1/(1+ KNNdis(Nom(i),loc));
            Gqp = Wqp/spdis;
            A(i,plabel) = A(i,plabel) + Gqp*Wqp;
            [VA(i),VP(i)] = max(A(i,:));
        end
    end
end




end