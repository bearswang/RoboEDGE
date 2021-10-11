function [obj, p, num_samples, obj2]= algorithm1(N, K, h, G, Pn, P, B, T, M, a, b, D, y, c)
p0=zeros(K,1);
for k=1:K
    p0(k)=P/K;
end

A=zeros(K,K);
for k=1:K
    for l=1:K
        A(k,l)=G(k,l)/Pn;
    end
end

for iter=1:10
    
    cvx_begin sdp quiet
    cvx_solver mosek
    % original variables
    variable p(K)
    
    variable myerror
    variable t(M)
    variable rate(K)
    variable slack1(K)
    variable slack2(K)
    
    minimize myerror
    subject to
    %
    % for m=1:M
    %     log(a(m))-b(m)*log(t(m))<=logerror;
    % end
    
    for m=1:M
        a(m)*pow_p(t(m),-b(m))<=myerror;
    end
    
    for m=1:M
        temp=0;
        for k=1:K
            temp=temp+y(k,m)*rate(k);
        end
        B*T/D(m)*temp+c(m)>=t(m);
    end
    
    p>=0;
    sum(p)==P;
    
    for k=1:K
        rate(k)<=1/log(2)*log(A(k,:)*p+1)-1/log(2)*log(A(k,:)*p0-A(k,k)*p0(k)+1)...
            -1/log(2)*1/(A(k,:)*p0-A(k,k)*p0(k)+1)*(A(k,:)*p-A(k,k)*p(k)-A(k,:)*p0+A(k,k)*p0(k));
        rate(k)>=0;
    end
    
    cvx_end
    
    p0=p;
    
end

num_samples = calculate_num(K, G, Pn, B, T, M, D, y, p, c);
s=zeros(M,1);
for m=1:M
    s(m)=a(m)*num_samples(m)^(-b(m));
end
obj=max(s);
obj2=sum(s)/M;


end

