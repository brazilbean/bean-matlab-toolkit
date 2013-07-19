%% append_fields - append the fields of one struct to another
% Gordon Bean, January 2012
%
% Usage
% out = append_fields( out, other )
%
% APPEND_FIELDS addes each field in 'other' to the struct 'out'.
% Any matching existing field will be overriden. 

function out = append_fields( out, other, varargin )
    if (isempty(varargin))
        fn = fieldnames(other)';
        strict = true;
    else
        if (islogical( varargin{end} ) )
            strict = varargin{end};
            fn = varargin(1:end-1);
        else
            fn = varargin;
            strict = true;
        end
    end
    
    if (~strict)
        fn2 = fieldnames(other);
        fn = intersect(fn, fn2);
    end
    for f = fn
        out.(f{1}) = other.(f{1});
    end
end