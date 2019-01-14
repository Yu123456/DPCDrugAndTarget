function rho=DPCDensity(dist, dc)
% 2017年3月30日
% DPC 高斯核局部密度函数

% dist  距离矩阵
% dc    截断距离

% 返回值
% rho   局部密度

[N,~] = size(dist);
rho = zeros(N,1);
% Gaussian kernel
for i=1:N-1
  for j=i+1:N
     rho(i)=rho(i)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
     rho(j)=rho(j)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
  end
end

end

