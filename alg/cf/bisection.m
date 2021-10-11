function [obj, p, num_samples]= bisection(N, K, h, G, Pn, P, B, T, M, a, b, D, y, u)
mu_ub=1;
mu_lb=0;

syms x;
Lambda1=@(x) max(Pn/norm(h(:,:,1))^2*exp(D(1)*log(2)/(B*T)*((x/a(1)).^(-1/b(1))-u(1))) -Pn/norm(h(:,:,1))^2, 0);
Lambda2=@(x) max(Pn/norm(h(:,:,2))^2*exp(D(2)*log(2)/(B*T)*((x/a(2)).^(-1/b(2))-u(2))) -Pn/norm(h(:,:,2))^2, 0);

p=zeros(K,1);

for iter =1:100
    mu=(mu_ub+mu_lb)/2;
    p(1)=Lambda1(mu);
    p(2)=Lambda2(mu);
    
    if sum(p)>=P
        mu_lb=mu;
    else
        mu_ub=mu;
    end
    
    if abs(mu_ub-mu_lb)<1e-8
        break;
    end
    
end


num_samples = calculate_num(K, G, Pn, B, T, M, D, y, p, u);
s=zeros(M,1);
for m=1:M
    s(m)=a(m)*num_samples(m)^(-b(m));
end
obj=max(s);


end

