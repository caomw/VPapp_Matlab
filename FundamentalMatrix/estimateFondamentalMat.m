function F = estimateFondamentalMat(xL, xR,  method)

n = size(xL,2);
%% Build matrix A
for i=1:n
    A(i,:) = [xL(1,i).*xR(:,i)' xL(2,i).*xR(:,i)' xR(1:2,i)'];
end

%% Get the fundamental matrix with one of the method
if(strcmp(method, 'entry'))
    B = -1*ones(n,1);
    F = A\B;
    F(9) = 1;
elseif(strcmp(method, 'norm'))
    A(:,9) = ones(8,1);
    [U, S, V] = svd(A);
    F = V(:,end); 
else
    display('Error : Wrong method name');
end

F = reshape(F,3,3)';

%% Enforcing the rank 2 constraint
if(rank(F)==3)
    [U,S,V] = svd(F);
    S(3,3) = 0;
    F = U*S*V';
end

