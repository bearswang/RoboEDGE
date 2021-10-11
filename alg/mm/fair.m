function [obj, p, num_samples, obj2]= fair(N, K, h, G, Pn, P, B, T, M, a, b, D, y, c)
d=[];
for k=1:K
    % according to eqn (59)
    d=[d;Pn./G(k,k)];
end
D2=diag(d); % D is defined in eqn (59)
R=zeros(K,K); % R is defined under (59)
for k=1:K
    for kk=1:K
        if kk==k
            R(k,kk)=0;
        else
            R(k,kk)=G(kk,k);
        end
    end
end
% Lambda is the matrix in eqn (60)
Lambda = [D2*R' D2*(ones(K,1).*Pn);1./P.*ones(K,1)'*D2*R' 1./P.*ones(K,1)'*D2*(ones(K,1).*Pn)];
[UL SL]=eig(Lambda);
eigs=diag(SL);
eig_max=max(eigs);
index =find(eigs==eig_max);
q_ext = UL(:,index); % the dominate eigenvector of eqn (60)
q_temp = q_ext(1:K)./q_ext(end); % recover the first 2K elements
p=reshape(q_temp,[K,1]); % update user powers

num_samples = calculate_num(K, G, Pn, B, T, M, D, y, p, c);
s=zeros(M,1);
for m=1:M
s(m)=a(m)*num_samples(m)^(-b(m));
end
obj=max(s);
obj2=sum(s)/M;

end

