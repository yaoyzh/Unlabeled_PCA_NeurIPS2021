% Algorithm 2 in the submitted paper "Unlabeled Principal Component Analysis"
function x_hat = LSR(A,y)
    [m,r] = size(A);
    
    for i=1:int64(m-r)
        x_hat = A\y;
        [~,idx] = max(abs(y-A*x_hat));
        y = [y(1:idx-1); y(idx+1:end)];
        A = [A(1:idx-1,:); A(idx+1:end,:)];
    end
 
end