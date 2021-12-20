function [x_hat, min_s, min_ub] = CCV_Min(A, y)
global eig_vals; global eig_vecs; global singular_vals; global qq;
global num_eig;  global m; global tolerance; global EM_iter;
global left_idx; global right_idx; global ub_idx; global lb_idx;  
global init_depth; global max_depth;

format shortG

    type = 'S';

    tolerance = 1e-4;
    
    EM_iter = 50;
    min_ub = inf;        
        
    [UA, Sigma, V] = svd(A,'econ');
    y = sort(y);
    
    [m, ~] = size(y);

    qq = repmat(sum(y.^2,2).', m, 1);
    qq = reshape(qq, m*m, 1);

    [eig_vals, eig_vecs] = decompose(UA, y);    
    singular_vals = sqrt(eig_vals);
    
    %% compute the initial rectangle
    num_eig = length(eig_vals);
            
    init_depth = 2*num_eig;

    rectangle_range = zeros(2, num_eig);
    for i=1:num_eig
        eig_vec = eig_vecs(:, i);
        cost_mat = reshape(eig_vec, m, m);
        [vec_idx, Q_idx, cost] = assignment(cost_mat, type);
        rectangle_range(1,i) = cost;
        
        % store the best solution so far
        ub = eval(eig_vals, eig_vecs, qq, vec_idx);
        if ub < min_ub
            min_ub = ub;
            min_s = vec_idx;
        end
        
        [vec_idx, Q_idx, cost] = assignment(-cost_mat, type);
        rectangle_range(2,i) = -cost;
        
        % store the best solution so far
        ub = eval(eig_vals, eig_vecs, qq, vec_idx);
        if ub < min_ub
            min_ub = ub;
            min_s = vec_idx;
        end
    end                 
    left_init = rectangle_range(1,:)';
    right_init = rectangle_range(2,:)';

    %% start the branch-and-bound
    
    if num_eig < 7
        % d = 10;
        max_depth = min(2*num_eig+2, 19);
    else
        max_depth = min(2*num_eig+4, 19);
    end

    % 3:init8max8, 4:init10max10, 5:init12max12=0.0027, 6:15,0.028
    % init_depth = 10;
    max_depth = 13;

    init_cube = [left_init; right_init; min_ub; 0; 0];                           
    
    cubes = split_cube(init_cube, init_depth);
          
    num_active_cubes = 2^init_depth;
    % num_active_cubes = 10000;
    
    left_idx = 1:num_eig;
    right_idx = (num_eig+1):(2*num_eig);
            
    ub_idx = 2*num_eig+1;
    lb_idx = 2*num_eig+2;    
    
    iter_count = 0;  
        
    while true
        iter_count = iter_count + 1; 
        [~, s] = size(cubes);

        if s == 0
            break;
        end            
       % [iter_count s min_ub]
        
        clb = cubes(lb_idx, :);   
        [~, minlb_idx] = sort(clb, 'descend');
        cubes = cubes(:, minlb_idx);      
                       
        nac = min(s, num_active_cubes); 
        active_cubes = cubes(:,1:nac);
        cubes = cubes(:,nac+1:end);
                
        %% compute upper and lower bounds
        [new_cubes, min_ub, min_s] = compute_with_active_cubes(active_cubes, min_ub, min_s, A, y, iter_count, type);
        
        cubes = [cubes(:,cubes(lb_idx,:)<min_ub-tolerance), new_cubes];              
        
        cubes = cubes(:, cubes(end,:) <= max_depth);        
    end    
    
    y_idx = (min_s-(1:m)')/m+1;

    x_hat = A\y(y_idx,:);
end

function ub = eval(eig_vals, eig_vecs, qq, vec_idx)
    ub = sum(qq(vec_idx)) - sum(eig_vecs(vec_idx,:), 1).^2*eig_vals;
end


function [vec_idx, y_idx, cost] = assignment(cost_mat, type)
    [m, m] = size(cost_mat);
    
    if strcmp(type, 'S')
        min_cost_mat = min(min(cost_mat));
        cost_mat = cost_mat - min_cost_mat; % make it non-negative       

        [y_idx, cost] = lapjv2(cost_mat);

        vec_idx = (1:m)' + (y_idx-1)*m;    

        cost = cost + min_cost_mat*m;
    else
        [cost, y_idx] = min(cost_mat, [], 2);
        vec_idx = (1:m)' + (y_idx-1)*m;
        cost = sum(cost);        
    end
end

function cubes = split_cube(init_cube, depth)
global singular_vals; global max_depth;
    cubes = [];
    if depth == 0
        cubes = init_cube;
    else        
        num_eig = length(singular_vals);
        right = init_cube(num_eig+1:2*num_eig);
        left = init_cube(1:num_eig);
%        singular_vals.*(right-left)
        %pause(2)
        [~, split_idx] = max(singular_vals.*(right-left));
        
        middle = (right+left)/2;
        
        subcubes = repmat(init_cube, 1, 2);
        subcubes(split_idx, 1) = middle(split_idx);
        subcubes(split_idx+num_eig,2) = middle(split_idx);
        subcubes(end,:) = subcubes(end,:) + 1;
        
        for i=1:2
            if subcubes(end,i) <= max_depth
                % max_depth
                cubes = [cubes split_cube(subcubes(:,i), depth-1)];
            end
        end                
    end    
end


function [eig_vals, eig_vecs]= decompose(UA, y)
    [Uy, Sigmay, ~] = svd(y,'econ');
    eig_vecs = kron(Uy, UA);
    [~, rank_A] = size(UA);
    
    eig_vals = diag(kron(Sigmay.^2, eye(rank_A)));
end

function [cubes, min_ub, min_s] = compute_with_active_cubes(active_cubes, min_ub, min_s, A, y, iter_count, type)
global eig_vals; global eig_vecs; global qq;
global k; global m; global tolerance; global EM_iter;
global left_idx; global right_idx; global ub_idx; global lb_idx;  
global init_depth;

    k = m;
    %% compute upper and lower bounds   
   
    for i=1:size(active_cubes,2)
        s = active_cubes(:,i);
        left = s(left_idx); right = s(right_idx); 
        v = qq-eig_vecs*(eig_vals.*(left+right));
        
        cost_mat = reshape(v, k, m);
        
        
        [vec_idx, y_idx, cost] = assignment(cost_mat, type);            

        active_cubes(ub_idx,i) = eval(eig_vals, eig_vecs, qq, vec_idx);
        if active_cubes(ub_idx,i) < min_ub
            min_ub = active_cubes(ub_idx,i);
            min_s = vec_idx;
        end            
        active_cubes(lb_idx, i) = cost + sum(eig_vals.*left.*right);
        % if iter_count <= 100eig
            % [v_idx, y_idx, ub] = EM(A, y, y_idx, EM_iter, type);
            % tic;
            [v_idx, y_idx, ub] = EM_v2(A, y, y_idx, EM_iter);
            % toc;
            
             if ub < min_ub
               min_ub = ub;
               min_s = v_idx;
             end
        % end
    end        

    idx2 = (active_cubes(lb_idx,:) < min_ub-tolerance);
    
    active_cubes = active_cubes(:,idx2);
    active_cubes = active_cubes(:, active_cubes(lb_idx,:) < min_ub-tolerance);
        
    [sz1,sz2] = size(active_cubes);
    
    %sort(active_cubes);
    clb = active_cubes(lb_idx, :); 
    [~, minlb_idx] = sort(clb);
    num_split = min(2^init_depth, sz2);
    
    active_cubes = active_cubes(:, minlb_idx);
    
    % cubes = zeros(sz1, num_split+sz2);
    cubes = [];
    % idx = 1;
    for i=1:num_split
        % cubes(:, idx:(idx+1)) = split_cube(active_cubes(:, i), 1);
        cubes = [cubes split_cube(active_cubes(:, i), 1)];
       %  size(cubes)
        % idx = idx + 2;
    end
    cubes = [cubes active_cubes(:, num_split+1:end)];
    % cubes(:, 2*num_split+1:end) = active_cubes(:, num_split+1:end);   
end



function [vec_idx, y_idx, ub] = EM_v2(A, y, y_idx, EM_iter)

    [k, n] = size(A);
    [m, ~] = size(y);
    
    x0 = A\y(y_idx,:);
    [x_hat, mle_e] = SLR_hardEM_v2(A, y, x0, EM_iter);
    [y_hat, idx] = sort(A*x_hat);
    I = eye(m);
    y_idx = I(idx,:)'*(1:m)';
    ub = mle_e^2;
    vec_idx = (1:m)' + (y_idx-1)*m; 
end

