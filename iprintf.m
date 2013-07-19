%% IPRINTF - Interleaved fprintf
% Gordon Bean, September 2011
%
% IPRINTF expects the data to be passed as cell arrays or numeric arrays.
% It will perform the fprintf function using the nth row in each array as
% inputs. 
%
% Usage
% iprintf( fid, format, ... )
% string_array = iprintf( format, ... )
%
% Examples
% >> foo = {'a'; 'b'; 'c'};
% >> iprintf(1, '%s:%2.0f-%0.0f\n', foo, rand(3,2)*10)
% a: 7-0
% b: 3-4
% c:10-4
%
% NOTE: The data inputs should be the the same size along dimension 1.
%

function string_out = iprintf( fid, format, varargin )

    
    if ( isnumeric( fid ) )
        % Check input lengths
        data = varargin;
        nD = length(data);

        size1 = @(x) size(x,1);
        data_len = cellfun(size1, data);
        if (numel(unique(data_len)) ~= 1)
            error(['IPRINTF: Inputs are not of equal length. ' ...
                sprintf('%1.0f ', data_len(:))]);
        end
        N = data_len(1);
        
        size2 = @(x) size(x,2);
        N2 = sum(cellfun(size2, data));
        
        % Print to file
        for v = 1 : N
            tmp = cell(N2,1);
            pos = 1;
            for d = 1 : nD
                if (iscell(data{d}))
                    for ii = 1 : size2(data{d})
                        tmp{pos} = data{d}{v,ii};
                        pos = pos + 1;
                    end
                else
                    for ii = 1 : size2(data{d})
                        tmp{pos} = data{d}(v,ii);
                        pos = pos + 1;
                    end
                end
            end

            fprintf(fid, format, tmp{:});
        end
        
    else
        % Print to string
        data = [{format} varargin];
        format = fid;
        
        % Check input lengths
        nD = length(data);

        size1 = @(x) size(x,1);
        data_len = cellfun(size1, data);
        if (numel(unique(data_len)) ~= 1)
            error('IPRINTF: Inputs are not of equal length.');
        end
        N = data_len(1);
        
        size2 = @(x) size(x,2);
        N2 = sum(cellfun(size2, data));
        
        % Print to a cell array of strings
        string_out = cell(N,1);
        for v = 1 : N
            tmp = cell(N2,1);
            pos = 1;
            for d = 1 : nD
                if (iscell(data{d}))
                    for ii = 1 : size2(data{d})
                        tmp{pos} = data{d}{v,ii};
                        pos = pos + 1;
                    end
                else
                    for ii = 1 : size2(data{d})
                        tmp{pos} = data{d}(v,ii);
                        pos = pos + 1;
                    end
                end
            end

            string_out{v} = sprintf(format, tmp{:});
        end
        if (N == 1)
            % Print to a single string
        	string_out = string_out{1};
            
        end
        
    end

end