% This function prints a correlation matrix to file to be loaded in Cluster
% 3.0 and view with JavaTreeView
% Gordon Bean, April 2010

function print_correlation_file (myCorr, names, filename)
    if (nargin < 3)
        filename = 'correlation_matrix.txt';
    end
    
    if (iscell(names{1}))
        names1 = names{1};
        names2 = names{2};
    else
        names1 = names;
        names2 = names;
    end
    N1 = length(names1);
    N2 = length(names2);
    
    % Remember to remove NaN's with VIM
    fid = fopen (filename, 'wt');
    fprintf(fid, ' ');
    fprintf(fid, '\t%s', names2{:});
    fprintf(fid, '\n');

    for a = 1 : N1
        if (isnan(myCorr(a,1)))
            fprintf(fid, '%s\t', names1{a});
        else
            fprintf(fid, '%s\t%f', names1{a}, myCorr(a,1));
        end
        for b = 2 : N2
            if (isnan(myCorr(a,b)))
               fprintf(fid,'\t'); 
            else
              fprintf(fid, '\t%f', myCorr(a,b));
            end
        end
        fprintf(fid, '\n');
    end
    fclose(fid);

end % of print_correlation_file