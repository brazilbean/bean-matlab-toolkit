%% Get feedback
% Gordon Bean, December 2012

function fb = get_feedback( value, context, fb )

    if (nargin < 3)
        fb = struct; 
    end

    % Display context
    fns = fieldnames(context)';
    for fn = fns
        fprintf('  %s: %s\n', fn{:}, context.(fn{:}));
    end
    
    ci = [];
    try
        while (isempty(ci))
            % Input
            inp = input(':: ', 's');

            % Record input
            ci = achar( inp, fns );
        end
    catch e
        return;
    end
    
    if (~isfield( fb, fns{ci}))
        evalstr('fb.(''%s'') = repmat( value, [0 0]);', fns{ci} );
    end
    fb.(fns{ci}) = cat(1, fb.(fns{ci}), value );
end