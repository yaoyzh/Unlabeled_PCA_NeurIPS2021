function C = selfRepresentation(data, func)
% Compute self representation data = data * C by calling column-wise solvers
% func: solver for c = func(X, y);

D = size(data, 1);
N = size(data, 2);

rows = cell(1, N);
vals = cell(1, N);
counter = 0;

c = zeros(N, 1);
nnzE = 0;
for ii = 1:N
    c([1:ii-1, ii+1:end]) = func( data(:, [1:ii-1, ii+1:end]), data(:, ii) );
    c(ii) = 0;
    
    supp = find( c );%abs(c) > 1e-3 * norm(c, 1) );
    rows{ii} = supp;
    vals{ii} = c(supp);
    counter = counter + length(supp);
    if mod(ii, 1000) == 0
        if outflag
            fprintf('Up to %d points, nonzero entries: %d\n', ii, counter);
        end
    end
end

C = sparse([],[],[], N, N, counter);
for ii = 1:N
    C(rows{ii}, ii) = vals{ii};
end
