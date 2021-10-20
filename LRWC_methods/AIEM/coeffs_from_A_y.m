function data = coeffs_from_A_y(A, y)
    n = size(A, 2);
    
    yn = zeros(n, 1);
    data0 = [];
    for k = 1:n
        yn(k,1) = sum(y.^k);    
        data0 = [data0(:); sum(veronese(A',k,1),2)];
    end
    data = [yn; data0];
end