xin = [5000, 10000, 20000, 30000, 40000, 50000];
yout = [
1-0.1921  
1-0.1392
1-0.1043
1-0.0950
1-0.0731
1-0.0689
]

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
xin_s=[5000:100:50000];
yout_s=zeros(length(xin_s),1);
for i=1:length(xin_s)
    yout_s(i)=F(xin_s(i));
end

plot(xin_s,yout_s,'-k');
save('resnet.mat');



