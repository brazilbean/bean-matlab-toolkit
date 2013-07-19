%% TopN - identify the top N values
% Gordon Bean, August 2010
%
% This function returns a logical matrix representing the top N
%  elements in a matrix or vector
%
% Usage
% top = topn( data, n )
% top = topn( data, n, dir )
%
% 'data' is the matrix (or array) of values
% 'n' indicates the number of largest values to identify
% 'dir' is either 'ascend' or 'descend' and is passed to 'sort'. The
%   default is 'descend', meaning that topn will find the top n most
%   positive values.
%
% Example
% >> foo = rand(3,3);
% >> foo(1,1) = nan
% 
% foo =
% 
%           NaN      0.63287      0.72932
%       0.49672       0.6884      0.85985
%       0.80865      0.63957      0.62696
% 
% >> topn( foo, 3 )
% 
% ans =
% 
%      0     0     1
%      0     0     1
%      1     0     0
% 
% >> topn( foo, 3, 'ascend' )
% 
% ans =
% 
%      0     1     0
%      1     0     0
%      0     0     1
% 

function [top] = topn (data, N, dir) 
    
    if (nargin < 3)
        dir = 'descend';
    end    

    nanmask = isnan(data);
    
%     if (numel(data) < N)
    if (sum(~nanmask(:)) < N)
        fprintf(2,'topN: Less than %i non-NaN elements in the data!\n',N);
        top = ~nanmask;
        return;
    end
    
    tmp = data(~nanmask);
    [~, order] = sort(tmp, dir);
    
    tmp2 = zeros(size(tmp));
    tmp2(order(1:N)) = 1;
    
    top = zeros(size(data));
    top(~nanmask) = tmp2 == 1;
    
    if (length(tmp) <= N+1 && tmp(N+1) == tmp(N))
        fprintf(2, 'topN: Tie between N and N+1! %f \n',tmp(N+1));
    end
    
%     data2 = cat(3,data,...
%         (1:size(data,1))'*ones(1,size(data,2)),...
%         ones(size(data,1),1) * (1:size(data,2)) );
%     
%     tmp = sortrows(reshape(data2,[size(data2,1)*size(data2,2),3]),1);
%     top = zeros(size(data));
%     
%     last_nonnan = size(tmp,1) - 1;
%     while (last_nonnan > 0 && isnan(tmp(last_nonnan,1)))
%         last_nonnan = last_nonnan - 1;
%     end
%     if (last_nonnan < N)
%         fprintf(2,'Less than %i ~NaN''s!\n',N);
%         top = ~isnan(data);
%         return;
%     end
%     
%     for a = 0 : N-1
%         top(tmp(last_nonnan-a,2),tmp(last_nonnan-a,3)) = 1;
%     end
%     if (tmp(end-N,1) == tmp(end-N+1,1))
%         fprintf(2, 'Tie between N and N + 1! %f \n', tmp(end-N,1));
%     end
%     
end % of topn