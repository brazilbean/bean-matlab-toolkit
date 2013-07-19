%% Plot Precision vs Recall
% Gordon Bean, May 2011
% [tp fp tn fn]
% Input should be a cell array

function [pr re] = plot_pr ( data_, varargin )

    if (isstruct(data_))
        data = struct2cell(data_);
    else
        data = data_;
    end
    
    if (nargout > 0)
        [pr re] = deal( cell(length(data),1) );
    end
    
    for d = 1 : length(data)
        yy = data{d}(:,1) ./ (data{d}(:,1) + data{d}(:,2));
        xx = data{d}(:,1) ./ (data{d}(:,1) + data{d}(:,4));
        plot(xx, yy, 'linewidth', 2, varargin{:});
        
        if (nargout > 0)
            pr{d} = yy;
            re{d} = xx;
        end
        
        if (d == 1), hold all; end
    end
    
    hold off;
    labels('Recall','Precision');
    
    if (isstruct(data_))
        h = legend( upper(fieldnames(data_)));
        set(h, 'Interpreter', 'none');
    end
end