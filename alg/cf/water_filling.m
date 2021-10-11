function [obj, p, num_samples, obj2]= water_filling(N, K, h, G, Pn, P, B, T, M, a, b, D, y, c)
temp=0;
for k=1:K
temp=temp+Pn/norm(h(:,:,k))^2;
end

lambda_ub=K/P/log(2);
lambda_lb=K/(P+temp)/log(2);
p=zeros(K,1);

for iter =1:100
lambda=(lambda_ub+lambda_lb)/2;

for k=1:K
p(k)=max(1/lambda/log(2)-Pn/norm(h(:,:,k))^2,0);
end

if sum(p)>=P
lambda_lb=lambda;
else
lambda_ub=lambda;
end

if abs(lambda_ub-lambda_lb)<1e-8
break;
end

end

num_samples = calculate_num(K, G, Pn, B, T, M, D, y, p, c);
s=zeros(M,1);
for m=1:M
s(m)=max(a(m)*num_samples(m)^(-b(m)),0);
end
obj=max(s);
obj2=sum(s)/M;


end

