clear all;
close all;

load('K2N100.mat'); % load channels
P = 0.02; % total transmit power in W
sigma = -77; % in dBm
Pn = 0.001*10.^(sigma/10);
monte = 10;
T = 5; % in second
B =180*10^3; % in Hz
N_vec=[10 20 40 100];

M=2;
a = [7.3; 5.2]; % error function parameters, model complexity
b = [0.69; 0.72]; % error function parameters, data quality
D = [6276; 324]; % number of bits for each sample
weight=[1;1.2];
aw=a.*weight;
c = [300; 200]; % initial number of samples
y = zeros(K,M);
num = 1;
y(:,1) = [ones(num,1);zeros(K-num,1)];
y(:,2) = ones(K,1)-y(:,1);

error0 = zeros(monte,length(N_vec));
error1 = zeros(monte,length(N_vec));
error2 = zeros(monte,length(N_vec));
error3 = zeros(monte,length(N_vec));
 
P0 = zeros(K,monte,length(N_vec));
P1 = zeros(K,monte,length(N_vec));
P2 = zeros(K,monte,length(N_vec));
P3 = zeros(K,monte,length(N_vec));

size0 = zeros(monte,M,length(N_vec));
size1 = zeros(monte,M,length(N_vec));
size2 = zeros(monte,M,length(N_vec));
size3 = zeros(monte,M,length(N_vec));

for s=1:1:length(N_vec)
    N=N_vec(s);
    fprintf('Starting simulating N=%d......\n',N_vec(s));
    for mon=1:monte                
        % channel
        h=h_m(1:N,:,:,mon);
        
        w=zeros(N,1,K);
        for k=1:K
            w(:,:,k)=h(:,:,k)./norm(h(:,:,k));
        end
        
        G=zeros(K,K);
        for k=1:K
            for l=1:K
                G(k,l)=norm(w(:,:,k)'*h(:,:,l))^2;
            end
        end
                
%         tic;
%         [obj1, p1, size1(mon,:,s)]= algorithm1(N, K, h, G, Pn, P, B, T, M, aw, b, D, y, c);
%         P1(:,mon,s)=p1;
%         error1(mon,s)=obj1;
%         t1(mon,s)=toc;

        tic;
        [obj0, p0, size0(mon,:,s)]= bisection(N, K, h, G, Pn, P, B, T, M, aw, b, D, y, c);
        error0(mon,s)=obj0;
        P0(:,mon,s)=p0;
        t0(mon,s)=toc;
        
        tic;
        [obj2, p2, size2(mon,:,s)]= water_filling(N, K, h, G, Pn, P, B, T, M, aw, b, D, y, c);
        error2(mon,s)=obj2;
        P2(:,mon,s)=p2;
        t2(mon,s)=toc;
        
        tic;
        [obj3, p3, size3(mon,:,s)]= fair(N, K, h, G, Pn, P, B, T, M, aw, b, D, y, c);
        error3(mon,s)=obj3;
        P3(:,mon,s)=p3;
        t3(mon,s)=toc;
    end
end

Avg_err0=sum(error0,1)./monte;
Avg_err1=sum(error1,1)./monte;
Avg_err2=sum(error2,1)./monte;
Avg_err3=sum(error3,1)./monte;

Avg_P0k1=reshape(sum(P0(1,:,:),2),[length(N_vec),1])./monte;
Avg_P0k2=reshape(sum(P0(2,:,:),2),[length(N_vec),1])./monte;
Avg_P1k1=reshape(sum(P1(1,:,:),2),[length(N_vec),1])./monte;
Avg_P1k2=reshape(sum(P1(2,:,:),2),[length(N_vec),1])./monte;
Avg_P2k1=reshape(sum(P2(1,:,:),2),[length(N_vec),1])./monte;
Avg_P2k2=reshape(sum(P2(2,:,:),2),[length(N_vec),1])./monte;
Avg_P3k1=reshape(sum(P3(1,:,:),2),[length(N_vec),1])./monte;
Avg_P3k2=reshape(sum(P3(2,:,:),2),[length(N_vec),1])./monte;

save('twouser.mat');

