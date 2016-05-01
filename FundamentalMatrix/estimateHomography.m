function H = estimateHomography(X,x)

j=1;
for i=1:size(x,2)
    A(j:j+1,:) = [-X(:,i)' zeros(1,3) x(1,i).*X(:,i)';
        zeros(1,3) -X(:,i)' x(2,i).*X(:,i)'];
    j=j+2;
end
[U,S,V] = svd(A);
P = V(:,end);
H = reshape(P,3,3)';