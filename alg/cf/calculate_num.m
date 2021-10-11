function num_samples = calculate_num(K, G, Pn, B, T, M, D, y, p, c)
num_samples=c;
for m=1:M
    for k=1:K
        if y(k,m)==1
            interf=0;
            for l=1:K
                if l~=k
                    interf=interf+p(l)*G(k,l);
                end
            end

            rate=1/log(2)*log(1+G(k,k)*p(k)/(interf+Pn));
            samplek=floor(B*T/D(m)*rate);
            num_samples(m)=num_samples(m)+samplek;
        end
    end
end
end

