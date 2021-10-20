% See the paper: 
% M. Slawski, E. Ben-David, P. Li,  
% "A Two-Stage Approach to Multivariate Linear Regression with Sparsely Permuted Data" 
% Journal of Machine Learning Research, 2020.
function [x_hat] = PL(A, yperm)
  %%%% compute initial estimators (naive)
    % [size(A)  size(yperm)]
    [n, d] = size(A);
    beta = A  \ yperm;
    sigma = norm(A*beta - yperm)/sqrt(n);
    alpha = 0.5;
    
    nloglik = @(b, sigma, alph) mean(-log(alph * (1/sqrt(2 * pi * sigma^2)) * exp(-(yperm - (A * b)).^2/(2 * sigma^2))...
        + (1-alph) * (1/sqrt(2 * pi * (norm(b)^2 + sigma^2))) * exp(-yperm.^2 / (2 * (norm(b)^2 + sigma^2)))));
    nloglik_cur = nloglik(beta, sigma, alpha);
    
    nit = 100;
    it = 0;
    tol = 1e-4;
    gamma = 0.95;
    nloglikvals = zeros(nit+1, 1);
    nloglikvals(1) = nloglik_cur;
      
    while it <= nit
        
        r = A*beta - yperm;
        
        pnum =  alpha * (1/sqrt(2 * pi * sigma^2)) * exp(-(r.^2)/(2*sigma^2 ));
        pdenom = pnum + (1 - alpha) * (1/sqrt(2 * pi * (norm(beta)^2 + sigma^2))) * exp(-yperm.^2 / (2 * (norm(beta)^2 + sigma^2)));
        pcur = pnum ./ pdenom;
        w = pcur;
        
        Aw = A;
        yw = sqrt(w) .* yperm;
        
        for ii=1:n
            Aw(ii,:) = sqrt(w(ii)) * A(ii,:);
        end
        
        gradbeta = @(b, sigma) (1/sigma^2) * (Aw'*(Aw * b - yw)) - b * (sum((1-pcur).*yperm.^2)/((sigma^2 + norm(b)^2)^2) - sum((1-pcur))/(sigma^2 + norm(b)^2));
        gradsigma = @(b, sigma) -sum((Aw * b - yw).^2)/(2*sigma^4) + sum(pcur)/(2*sigma^2) - sum((1-pcur).*(yperm.^2))/(2*(sigma^2 + norm(b)^2)^2) + 0.5*sum(1-pcur)/(sigma^2 + norm(b)^2);
        
        Ehess_bb = @(b, sigma) (Aw' * Aw)/sigma^2 + 2 * sum((1-pcur)./((sigma^2 + norm(b)^2)^2)) * b*b';
        Ehess_bsigma = @(b, sigma) sum((1-pcur)./((sigma^2 + norm(b)^2)^2)) * b;
        Ehess_sigmasigma = @(b, sigma)  sum(0.5 * pcur / sigma^4) +  sum(0.5*(1-pcur).*(1/((sigma^2 + norm(b)^2)^2)));
        
        gr = [gradbeta(beta, sigma); gradsigma(beta, sigma)];
        Hess = [Ehess_bb(beta, sigma) Ehess_bsigma(beta, sigma); Ehess_bsigma(beta, sigma)' Ehess_sigmasigma(beta, sigma)];
        dir = Hess \ (-gr);%-gr;
        
        %%% do inexact line search based on Armijo rule
        m = 0;
        while true
            
            betanew = beta + gamma^m * dir(1:(end-1));
            sigmanew = sqrt(sigma^2 + (gamma^m) * dir(end));
            alphanew = sum(pcur)/n;
            
            nloglik_new = nloglik(betanew, sigmanew, alphanew);%nloglik(betanew, sigmanew, alphanew);
            if ~isreal(nloglik_new)
                m = m+1;
            else
                if  nloglik_cur - nloglik_new > tol %-tau * gamma^m * dot(dir, gr)
                    nloglik_cur = nloglik_new;
                    beta = betanew;
                    sigma = sigmanew;
                    alpha = alphanew;
                    break;
                else
                    m = m+1;
                end
            end
            
            if gamma^m < tol^2
                break;
            end
        end
        
        it = it+1;
        
        if gamma^m < tol^2
            break;
        end
        
        nloglikvals(it+1) = nloglik_cur;
        
    end
    
    x_hat = beta;       
end