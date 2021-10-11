function [obj, p, num_samples]= sumrate(N, K, h, G, Pn, P, B, T, M, a, b, D, y, c)
w0=zeros(N,1,K);
p0=zeros(K,1);
slack20=zeros(K,1);
for k=1:K
    w0(:,:,k)=h(:,:,k)./norm(h(:,:,k));
    p0(k)=P/K;
end

A=zeros(K,K);
for k=1:K
    for l=1:K
        A(k,l)=G(k,l)/Pn;
    end
end

for k=1:K
interf=0;
    for l=1:K
        if l~=k
            interf=interf+norm(w0(:,:,k)'*h(:,:,l))^2*p0(l);
        end
    end
    slack20(k)=interf+Pn;
end

for iter=1:10

cvx_begin sdp quiet
cvx_solver mosek
% original variables
variable p(K)

variable rate(K)
variable slack1(K)
variable slack2(K)

maximize sum(rate)
subject to

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
w=w0;


num_samples = calculate_num(K, G, Pn, B, T, M, D, y, p, c);
s=zeros(M,1);
for m=1:M
if num_samples(m)==0
s(m)=0.1;
else
s(m)=a(m)*num_samples(m)^(-b(m));
end
obj=max(s);


end

