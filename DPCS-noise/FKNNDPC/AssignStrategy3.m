function ClassLabel = AssignStrategy3(classlabel,KNNA)
% 本程序编写于 2017 年 8 月 22 日
% FKNN-DPC 赋值策略 3

% 输入：
% classlabel  点的类别标签，0 表示未进行标签赋值
% CI     簇中心点
% K      最近邻数
% KNNA    完整最近邻索引矩阵，对应 dist 矩阵


% 输出：
% ClassLabel  点的类别标记

ClassLabel = classlabel;
% 如果没有标签为 0 的点，则说明已经全部赋值，无需进行处理
N = length(ClassLabel);
if sum( ClassLabel == 0 ) ~= 0
    for i=1:N
        if ClassLabel(i) == 0
            bool = 1;
            j = 1;
            while bool
                j = j+1;
                if ClassLabel(KNNA(i,j)) ~= 0
                    ClassLabel(i) = ClassLabel(KNNA(i,j));
                    bool = 0;
                end
            end
        end
    end
end


end

