% Gordon Bean, September 2010
% Returns the true pos, false pos, true neg, false neg

function [ stats, data ] = tfpn_cont (truth, data)
    truth = truth(:);
    data = data(:);

    [~,ord] = sort(-data(:));
    tp = cumsum(truth(ord)==1);
    fp = cumsum(truth(ord)==0);
    
    stats = [...
        tp ... True Positives
        fp ... False Positives
        sum(~truth) - fp ... True Negative
        sum(truth) - tp ... False Negative
        ];
    
    if (nargout > 1)
        data = [data(ord) truth(ord)];
    end
end