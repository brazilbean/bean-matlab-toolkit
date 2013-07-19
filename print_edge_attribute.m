% This function prints a Cytoscape edge attribute format file
% Gordon Bean, April 2010, June 2011

% NOTE: this function does not print self edges (i.e. a->a)
% NOTE: this function does not assume symmetry

function print_edge_attribute (filename, attr_name, names, data, itype)
    if (nargin < 5)
        itype = 'gg';
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

    fid = fopen(filename,'wt');
    fprintf(fid, '%s\n', attr_name);
    
    for b = 1 : N2
        tmp = cell(size(names1));
        tmp(:) = names2(a);
        
        tmp2 = cell(size(names1));
        tmp2(:) = {itype};
        
        foo = [names1 tmp2 tmp num2cell(data(:,b))]';
        fprintf(fid,'%s (%s) %s = %f\n', foo{:});
    end

%     for a = 1 : N1
%         for b = 1 : N2
%             if (a == b), continue, end;
%             fprintf(fid,'%s (%s) %s = %f\n',...
%                 names1{a},itype,names2{b},data(a,b));
%         end
%     end

    fclose(fid);

end % of print_edge_attribute
