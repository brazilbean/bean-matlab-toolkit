%% Closure - a callable object
% Gordon Bean, June 2013

classdef Closure
    
    methods
        function this = Closure()
            % Nothing to initialize
        end
        
        function out = subsref(this, call)
            if length(call) == 1 && strcmp(call.type,'()')
                % Call the method defined by call_hook
                out = this.closure_method(call.subs{:});
            elseif strcmp(call(1).type, '.')
                % . operator used
                if length(call) == 2 && strcmp(call(2).type,'()')
                    % Trying to access method
                    out = this.(call(1).subs)(call(2).subs{:});
                else
                    % Trying to access property
                    out = this.(call(1).subs);
                end
            end
        end
        function out = closure_method(this, varargin)
            error('closure_method not overriden by subclass!');
        end
    end
end