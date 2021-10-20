function [xopt, varargout] = rfss( K, y, alpha, beta, varargin )

    % [xopt, varargout] = rfss( K, y, alpha, beta, varargin )
    %
    % Algorithm for l1- and Elastic-Net-minimization, i.e. for the functional
    %   Phi(x) = 0.5*||K*x-y||_2^2 + ||alpha.*x||_1 + 0.5*||sqrt(beta).*x||_2^2
    %
    %
    % Input:
    %   K:     Operator matrix or function handle. If function handle 'KT' has to be specified.
    %   y:     Data vector
    %   alpha: Vector with weights >0 of the same size as input vectors for K ( it may be a scalar >0 if K is a matrix)
    %   beta:  Vector with weights >0 of the same size as input vectors for K ( it may be a scalar >0 if K is a matrix)
    % Optional input
    %   'maxIter':  Upper bound for the number of iterations (default:0 (->inf))
    %   'init':     Initial value (default 0)
    %   'tol':      Tolerance for accepting the optimality condition (default 0)
    %   'verbose':  Verbose mode for additional informations during iterations (default false)
    %   'KT':       Function handle for the adjoint operator
    % 
    % Output:
    %   xopt: Minimizer(if not stoped by maxIter) or last iterate.
    % Optional output
    %   exitflag: 0 if converged, 1 if iterations exceeded maxIter or loop detected
    %   iterCount: Number of iterations performed
    %   Phihist: A vector containing the values of Phi for each iterate.
    %           'verbose' must be true to get this output!
    %
    %
    % Example for use of optional parameters:
    %   [minimizer,exitflag]=rssn(K,y,alpha,beta,'verbose',true,'tol',0);
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This algorithm relates on the article cited above. The comments in this %
    % source code refers to the description of the RFSS there.                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    %% DO NOT....
    % simplify the algorithm by setting KT=@(x) K'*x if K is a matrix
    % because this function handle slows down the algorithm considerably!
    
    %% Setting defaults
    % Tolerance for accepting the optimality condition
    TOL = 0.0;
    %verbose mode
    verbose = false;
    %initial value must be known only on the active set so in the beginning
    %it is empty
    x=zeros(0,1); 
    activeSet=[];
    %number of iterations (not constrained by default)
    maxIter = 0;
    Phihist=[];
    KT=0;

    if max(size(alpha)) == 1 
        if isa(K, 'function_handle')
            error('If operator is given as a function handle alpha must be specified as a vector of the same length as input vectors for K');
        end
        alpha = zeros(size(K,2),1)+alpha;
    end
    
    if max(size(beta)) == 1
        if isa(K, 'function_handle')
            error('If operator is given as a function handle beta must be specified as a vector of the same length as input vectors for K');
        end
        beta = zeros(size(K,2),1)+beta;
    end
    
    theta=0*alpha;
    
    %% Parsing optional parameters
    % KT is obligatory if op is a function handle
    if (rem(length(varargin),2)==1)
      error('RFSS: Optional parameters should always go by pairs');
    else
      for i=1:2:(length(varargin)-1)
        switch varargin{i}
         case 'init'
           fullx=varargin{i+1};
           activeSet=find(fullx~=0);
           x = fullx( activeSet );
         case 'maxIter'
           maxIter = varargin{i+1};
         case 'KT'
           KT = varargin{i+1};
         case 'tol'
           TOL = varargin{i+1};
         case 'verbose'
           verbose = varargin{i+1};
         otherwise
          error(['RFSS: Unrecognized option: ''' varargin{i} '''']);
        end;
      end;
    end
    
    if isa(K, 'function_handle') && ~isa(KT,'function_handle')
       error('The function handle for transpose of K is missing');
    end 

    if verbose
        disp(['RFSS: Starting algorithm with a tolarance of ' num2str(TOL) ' and ' num2str(maxIter) ' as maximal number of iterations.']);
    end

    %%
    % Some calculations in advance
    Ky=0;
    if isa(K, 'function_handle')
        Ky = KT(y);
    else
        Ky = K'*(y);
    end
    

    %% STEP 1: Initialization
    if verbose
        disp('RFSS STEP 1: Initialization');
    end
    theta(activeSet)=sign(x);
    alphaTheta=alpha.*theta;
    iterCount = 0;
    exitflag=0;%flag to indicate wether the algorithm converged or not
    Kact=zeros(length(y(:)),0);
    if isa(K,'function_handle')
        for k=1:length(activeSet)
            v=0*alpha;
            v(activeSet(k))=1;
            col = K(v);
            Kact = [Kact col(:)];
        end
    else
        Kact=K(:,activeSet);
    end
    KKact = Kact'*Kact;
    if verbose
        Phihist(end+1) = Phi(Kact,y,alpha(activeSet),beta(activeSet),x);
        disp(['RFSS STEP 1: Initial functional value is Phi(x)=' num2str( Phihist(end) ) ]);
    end
    
    %% if x was initialized with ~=0 we should optimize it on the active
    %% set before checking the optimality condition. This corresponds to
    %% step 3
    if ~isempty(activeSet)
        x=(KKact+diag(beta(activeSet)))\( Ky(activeSet) - alphaTheta(activeSet) );
    end

    %% Check optimality condition to see if the starting guess is already optimal, if not perform the iterations
    G=0;
    if isa(K, 'function_handle')
        G = KT(Kact*x - y);
    else
        G = K'*(Kact*x - y);
    end
    cond = (abs(G)-alpha);
    cond(activeSet)=0;
    [value,i0] = max( cond );
    if not( value <= TOL && (isempty(activeSet) || max(abs(G(activeSet) + beta(activeSet).*x + alphaTheta(activeSet)))<=TOL) )
        %% start iterations
        loopflag=0;%flag to exit iterations if loop was detected
        activeSetHist={sort(activeSet)};%History of active sets for loop detection
        while( maxIter==0 || iterCount<maxIter )

            %% STEP 2: increase active set
            activeSet=[activeSet; i0];
            activeSetHist={activeSetHist{:}, sort(activeSet)};
            theta(i0) = -sign(G(i0));
            alphaTheta(i0) = theta(i0)*alpha(i0);
            x=[x;0];

            if isa(K,'function_handle')
                v=0*alpha;
                v(i0)=1;
                col = K(v);
                Kact = [Kact col(:)];
            else
                Kact = [Kact K(:,i0)];
            end
            KKact = [KKact, Kact(:,1:end-1)'*Kact(:,end)];
            KKact = [KKact; Kact(:,end)'*Kact];
            if verbose
                disp(['RFSS STEP 2: Iteration: ' num2str(iterCount) ', adding index ' num2str(i0) ' to active set, now ' num2str(length(activeSet)) ' active components']);
            end

            while( maxIter==0 || iterCount<maxIter )
                iterCount = iterCount+1;

                %% STEP 3: update x 
                xneuact = (KKact+diag(beta(activeSet)))\( Ky(activeSet) - alphaTheta(activeSet) );

                if verbose
                    Phihist(end+1) = Phi(Kact,y,alpha(activeSet),beta(activeSet),xneuact);
                    disp(['RFSS STEP 3: Functional value now Phi(x)=' num2str( Phihist(end) ) ]);
                end

                %% STEP 4: check consistency and if necessary remove index from activeSet
                f=find( (theta(activeSet)-sign(xneuact)) ~= 0 );
                if min(size( f ))~=0
                    diff = xneuact-x;
                    lambda = -x(f(1)) /diff(f(1));
                    removeIndex=f(1);
                    for v = 2:length(f)
                        lambdatest =  -x(f(v)) /diff(f(v));
                        if lambdatest < lambda
                            lambda = lambdatest;
                            removeIndex=f(v);
                        end
                    end

                    if verbose
                        disp(['RFSS STEP 4: Iteration: ' num2str(iterCount) ', stepsize restricted, removed index ' num2str(activeSet(removeIndex)) ' from active set.']);
                    end

                    
                    
                    as = activeSet;
                    as(removeIndex)=[];
                    as=sort(as);
                    for i=1:length(activeSetHist)
                        if sum(size(as)==size(activeSetHist{i}))==2 && sum( as==activeSetHist{i})==length(as)
                            loopflag=1;
                            exitflag=1; %return the not converged flag!

                            fprintf(['RFSS: WARNING, NOT CONVERGED: LOOP DETECTED!!! \r\n' ...
                            'Loops happen if the inversion of K''*K is numerically unstable, or if the operator is given as a\r\n' ...
                            'function handle corresponding to ill-conditioned matrices.\r\n' ...
                            'You might want to increase the tolerance for accepting the optimality condition, it needs to be > %f',value]);
                            break;
                        end
                    end
                    %%if we hang inside a loop return...
                    if loopflag
                        break;
                    end

                    activeSet(removeIndex)=[];
                    activeSetHist={activeSetHist{:}, sort(activeSet)};
                    %update x and guarantee consistency
                    x = x+diff*lambda;
                    x(removeIndex)=[];
                    Kact(:,removeIndex)=[];
                    KKact(:,removeIndex)=[];
                    KKact(removeIndex,:)=[];
                    theta(activeSet) =sign(x);
                    alphaTheta(activeSet) = alpha(activeSet).*theta(activeSet);

                    %if the active set is empty now, we need to go one step back
                    %this might happen if the starting guess(init) is completly wrong!
                    %x needs to be reinitialized in that case since the removeindex code results in a 1x0 matrix and an empty x must be 0x1.
                    if isempty(activeSet)
                        x=zeros(0,1); 
                        break;
                    end
                    
                    %check optimality condition on the active set
                    test = KKact*x - Ky(activeSet) + beta(activeSet).*x + alphaTheta(activeSet) ;
                    if abs(test)<=TOL
                        break;
                    end
                else       
                    %if consistent, update x
                    x = xneuact;

                    break;
                end
            end

            %%if we hang inside a loop return...
            if loopflag
                break;
            end

            %% STEP 5: check optimality condition outside the active set
            %if we are here, the opt. cond is fulfilled on the active set.
            %remark that beta.*x is 0 on these components.
            if isa(K, 'function_handle')
                G = KT(Kact*x-y);
            else
                G = K'*(Kact*x -y);
            end
            cond = (abs(G)-alpha);
            cond(activeSet)=0;
            [value,i0] = max( cond );
            if value <= TOL
                break;
            end

        end
    end


    %% final output
    if verbose
        disp(['RFSS: Stopped with Phi(x)= ' num2str(Phihist(end)) ' and ' num2str(sum(x~=0)) ' active components']);
    end

    if iterCount>=maxIter && maxIter~=0
        exitflag=1;
        disp('RFSS: WARNING, NOT CONVERGED!!! Number of iterations exceeds your specified upper bound.');
    end
    
    varargout(1) = {exitflag};
    varargout(2) = {iterCount};
    varargout(3) = {Phihist(:)};
    
    xopt=0*alpha;
    xopt(activeSet) = x;

end


%%%%%%%%%%%%%%%%%%
%  subfunctions  %
%%%%%%%%%%%%%%%%%%

function v=Phi(K,y,alpha,beta,x)
    %if the activeset is empty, i.e. alpha and beta empty, we set them to 0*x since x is 0x1 and the dimensions must agree!
    if isempty(alpha)
        alpha=0*x;
        beta=0*x;
    end

    % calculates the value of the functional Phi at x
    residual=K*x - y;
    v = 0.5*norm(residual)^2 + sum(alpha.*abs(x)) + 0.5*sum(beta.*(x.^2));
end

