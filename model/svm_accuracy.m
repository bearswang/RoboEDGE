% Reference:
% S. Wang, Y.-C. Wu, R. Wang, M. Xia, and H. V. Poor,
% “Deep learning at massive MIMO edge with nonlinear accuracy model,?
% IEEE Transactions on Wireless Communications, 2019.
clear all;
xin =[30, 50, 100, 200]; % in bit

yout =[
0.5226130653266332
0.7487437185929648
0.7989949748743719
0.8555276381909548
]; % 
% yout =[
% 0.8077889447236181
% 0.8190954773869347
% 0.8680904522613065
% 0.8592964824120602
% ];
% Plot the data
semilogx(xin,yout,'square');
hold on;


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
%             if F1(xin(l))>yout(l)
%                 MSE(i,j)=MSE(i,j)+1e3;
%             end
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

semilogx(xin_s,yout_s,'-k');

save('svm.mat');

