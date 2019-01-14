function ClassLabel = AssignStrategy3(classlabel,KNNA)
% �������д�� 2017 �� 8 �� 22 ��
% FKNN-DPC ��ֵ���� 3

% ���룺
% classlabel  �������ǩ��0 ��ʾδ���б�ǩ��ֵ
% CI     �����ĵ�
% K      �������
% KNNA    ����������������󣬶�Ӧ dist ����


% �����
% ClassLabel  ��������

ClassLabel = classlabel;
% ���û�б�ǩΪ 0 �ĵ㣬��˵���Ѿ�ȫ����ֵ��������д���
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

