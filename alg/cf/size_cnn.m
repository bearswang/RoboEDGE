clear;
load('twouser.mat');
disp('***Proposed LDPA');
temp=size1(:,1,:);
for j=1:size(temp,3)
for i=1:size(temp,1)
    if i<size(temp,1)
    fprintf('%d,',temp(i,j));
    else
       fprintf('%d,\n',temp(i,j));
    end
end
end

disp('***Proposed analytical');
temp=size0(:,1,:);
for j=1:size(temp,3)
for i=1:size(temp,1)
    if i<size(temp,1)
    fprintf('%d,',temp(i,j));
    else
       fprintf('%d,\n',temp(i,j));
    end
end
end

disp('***Water filling');
temp=size2(:,1,:);
for j=1:size(temp,3)
for i=1:size(temp,1)
    if i<size(temp,1)
    fprintf('%d,',temp(i,j));
    else
       fprintf('%d,\n',temp(i,j));
    end
end
end

disp('***Max-min fairness');
temp=size3(:,1,:);
for j=1:size(temp,3)
for i=1:size(temp,1)
    if i<size(temp,1)
    fprintf('%d,',temp(i,j));
    else
       fprintf('%d,\n',temp(i,j));
    end
end
end