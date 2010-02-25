function [mu, assign, errHist] = kmeansFit(data, K, varargin)
% data(i,:) is i'th case
% mu(:,k) is k'th centroid
% assign(i) = cluster to which data point i is assigned
[maxIter, thresh, plotfn, verbose, mu] = processArgs(...
    varargin, '-maxIter', 100, '-thresh', 1e-3,...
    '-plotfn', [], '-verbose', false, '-mu', []);

[N, D] = size(data);
if isempty(mu)
    % initialize using K data points chosen at random
    perm = randperm(N);
    mu = data(perm(1:K), :)';
end
Y = data'; % Y(:,i) is i'th case
done = false;
iter = 1;
errHist = zeros(maxIter, 1); 

while ~done
    dist = sqDistance(Y', mu');   % dist(i,k)
    assign = minidx(dist, [], 2);
    %err = 0;
    %for k=1:K
    %    members = (assign==k);
    %    mu(:, k) = mean(data(members, :), 1)';
    %    err = err + sum(dist(members, k));
    %end
    mu = groupMean(data, assign, K)';
    err = sum(min(groupSum(dist, assign, K), [], 2))/N; 
    errHist(iter) = err;
    converged =  iter > 1 && convergenceTest(errHist(iter), errHist(iter-1), thresh);
    if ~isempty(plotfn), plotfn(data, mu, assign, err, iter); end
    if verbose, fprintf(1, 'iteration %d, err = %f\n', iter, errHist(iter)); end
    done = converged || (iter > maxIter);
    iter = iter + 1;
end
errHist = errHist(1:iter-1); 


end