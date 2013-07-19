% Gordon Bean, October 2010
% This function calculates the AUC (area under ROC curve)

function [area, X, Y] = auc (tfpn)
    if (iscell(tfpn))
        area = nan(size(tfpn));
        for a = 1 : length(tfpn)
            Y = sortrows(tfpn{a}(:,2)./(tfpn{a}(:,2)+tfpn{a}(:,3)));
            X = sortrows(tfpn{a}(:,1)./(tfpn{a}(:,1)+tfpn{a}(:,4)));
            area(a) = 0.5 * (2 - nansum( (X(2:end)-X(1:end-1)) ...
                .* (Y(2:end)+Y(1:end-1))));
        end
    else
        Y = sortrows(squeeze(tfpn(:,2,:))./squeeze(tfpn(:,2,:)+tfpn(:,3,:)) );
        X = sortrows(squeeze(tfpn(:,1,:))./squeeze(tfpn(:,1,:)+tfpn(:,4,:)) );
        area = 0.5 * ( 2 - nansum( (X(2:end,:)-X(1:(end-1),:)) ...
            .* ( Y(2:end,:)+Y(1:(end-1),:) ) ) );
    end
end