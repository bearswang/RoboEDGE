% Load experimental data of powercast P2110 at distances of 15,14,...,3,2,1 m
% Reference:
% [1] Powercast wireless power calculator. http://www.powercastco.com/power-calculator/.
% [2] S. Wang, M. Xia, K. Huang, and Y.-C. Wu,
% “Wirelessly powered two-way communication with nonlinear energy harvesting model: Rate regions under fixed and mobile relay,?
% IEEE Transactions on Wireless Communications, 2017.
xin =[100, 150, 200, 300]; % in bit
yout =[
0.703000009059906
0.7670000195503235
0.7850000262260437
0.8820000290870667
]; % 



% Plot the data
hold on;
plot(xin,yout,'square');

a_vec =0:0.01:10; % searching values for nu
b_vec =0:0.01:1; % searching values for tau

% Compute the MSEs
MSE=zeros(length(a_vec),length(b_vec));
for i=1:length(a_vec)
    for j=1:length(b_vec)
        a=a_vec(i);
        b=b_vec(j);
        F1=@(x) 1-a*x^(-b);
        for l=1:length(xin)
            MSE(i,j)=MSE(i,j)+abs(F1(xin(l))-yout(l))^2; % MSE with the unit of powers being dBm
        end
    end
end

% Find the minimum MSE and the corresponding index
index=find(MSE==min(min(MSE)));
[i1,j1] = ind2sub([length(a_vec),length(b_vec)],index);
a=a_vec(i1);
b=b_vec(j1);
F=@(x) 1-a*x^(-b);

% Plot the model
xin_s=[10:10:90,100:100:10000];
yout_s=zeros(length(xin_s),1);
for i=1:length(xin_s)
    yout_s(i)=F(xin_s(i));
end

plot(xin_s,yout_s,'-k');
save('dl.mat');



