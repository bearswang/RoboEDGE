clear all;
close all;

a = [1.6100; 1.7900]; % error function parameters, model complexity
b = [0.2200; 0.5400]; % error function parameters, data quality
D = [1.54*1024*1024*8; 705*1024*8]; % number of bits for each sample

T = 20; % s

R_sum_vec = [300,400,500];
K=2;
R1=zeros(K,length(R_sum_vec ));
R2=zeros(K,length(R_sum_vec ));
num_sample1=zeros(K,length(R_sum_vec ));
num_sample2=zeros(K,length(R_sum_vec ));

for iii = 1:length(R_sum_vec )
    R_sum = R_sum_vec(iii).*1e6;
    
    % baseline

    R=R_sum./2.*ones(K,1);
    R1(:,iii) = R;
    for k=1:K
        num_sample1(k,iii) = floor(T*R(k)/D(k));
    end
    
    % LC

    cvx_begin
    cvx_solver sedumi
    % original variables
    variable R(K)
    
    variable myerror(K)
    
    minimize sum(myerror)/2
    subject to
    %
    % for m=1:M
    %     log(a(m))-b(m)*log(t(m))<=logerror;
    % end
    
    for k=1:K
        a(k)*pow_p(T*R(k)/D(k),-b(k))<=myerror(k);
    end
    
    R>=0;
    sum(R)==R_sum;
    
    cvx_end
    R2(:,iii) = R;
    for k=1:K
        num_sample2(k,iii) = floor(T*R(k)/D(k));
    end
    
end

% err_min = 0;
% err_max = 1;
% iter_max=100;
% for iter=1:iter_max
%     err = (err_min+err_max)./2;
%     R_tmp = zeros(K,1);
%     for k=1:K
%         R_tmp(k) = (err./a(k))^(-1/b(k))*D(k)/T;
%     end
%     
%     if sum(R_tmp)>=R_sum
%         err_min = err;
%     else
%         err_max = err;
%     end
%     
%     if norm(err_max-err_min)<1e-6
%         break;
%     end
%     
% end
% R=R_tmp;


save('icc.mat');

