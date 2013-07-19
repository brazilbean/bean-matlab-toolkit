%% Subset
% Gordon Bean, December 2012

function sb = subset( rin, cin, data, rout, cout )

    switch class(data)
        case 'logical'
            sb = false(size(data));
        case 'double'
            sb = nan(size(data));
        case 'cell'
            sb = cell(size(data));
    end
    tmpr = achar( rout, rin, 1 );
    tmpc = achar( cout, cin, 1 );
    
    sb( ~isnan(tmpr), ~isnan(tmpc) ) = data(notnan(tmpr), notnan(tmpc));

end