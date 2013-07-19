% Gordon Bean, September 2010, June 2011
% Plots an ROC curve

function [fpr, tpr] = plot_roc ( tfpn_, varargin )

    if (isstruct(tfpn_))
        tfpn = struct2cell(tfpn_);
    else
        tfpn = tfpn_;
    end
    
    if (iscell(tfpn))
        % Newer Version
        for a = 1 : length(tfpn)
            fpr = tfpn{a}(:,2)./(tfpn{a}(:,2) + tfpn{a}(:,3));
            tpr = tfpn{a}(:,1)./(tfpn{a}(:,1) + tfpn{a}(:,4));
            
            plot(fpr, tpr, 'linewidth', 2, varargin{:});
            
            if (a == 1), hold all; end
        end
        
        hold off;
        line([0 1],[0 1],'Color','k');
        
    else

        % tfpn = [tp fp tn fn]
        % Multiple curves should be stacked in 3rd dimension
        % e.g. cat(3, tfpn1, tfpn2, etc.)

        % plot( false positive rate, true positive rate )

        fpr = squeeze(tfpn(:,2,:))./squeeze(tfpn(:,2,:)+tfpn(:,3,:));
        tpr = squeeze(tfpn(:,1,:))./squeeze(tfpn(:,1,:)+tfpn(:,4,:));

        plot(fpr , tpr, 'LineWidth', 2, varargin{:})
    
    end
    
    labels('False Positive Rate','True Positive Rate');
    
    if (isstruct(tfpn_))
        h = legend(upper(fieldnames(tfpn_)), 'location', 'southeast');
        set(h, 'Interpreter', 'none');
    end
    
    if (nargout < 2)
        fpr = auc( tfpn );
    end
end
