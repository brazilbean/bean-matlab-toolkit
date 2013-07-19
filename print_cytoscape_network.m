%% Print Cytoscape Network
% Gordon Bean, March 2011
%
% Print a data matrix to a table format for importing into Cytoscape. 
%
% Usage
% print_cytoscape_network( filename, rowlabels, collabels, criteria )
% print_cytoscape_network( filename, rowlabels, collabels, criteria, ...
%   edge_attribute_names, edge_attributes )
%
% 'filename' denotes the name of the file to print to.
% 'rowlabels' denotes the names of the rows of the data.
% 'collabels' denotes the names of the columns of the data.
% If both 'rowlabels' and 'collabels' are cell arrays of length 2 and
%   contain cell arrays of strings, the first set of strings are assumed to 
%   be gene names and the second set of strings are assumed to be orfs.
%
% 'criteria' is an m x n logical matrix indicating which interactions
%   should be printed. 
% 'edge_attribute_names' is a cell array of strings which label the edge
%    attributes. They will be used as column headers in the file for the
%    additional columns listed in edge_attributes.
% 'edge_attributes' is a cell array of m x n matrixes from which the values
%   corresponding to the criteria will be printed as extra columns.
%
% Examples
% - Print with edge attributes using a symmetric dataset - 
% >> print_cytoscape_network( 'positive_intxns.net', ...
%       emap.genes, emap.genes, emap.ut.ave > 3, ...
%       {'s-score','correlation'}, {emap.ut.ave, emap.ut.corr} );
%
% - Print just the edges, no attributes, using a non-symmetric dataset -
% >> print_cytoscape_network( 'negative_intxns.net', ...
%       emap.rows, emap.cols, emap.ut.scorematL.data < -3 );
%
% - Print just the edges, no attributes, including orf and gene names -
% >> print_cytoscape_network( 'negative_intxns.net', ...
%       {emap.rows, emap.roworfs}, {emap.cols, emap.colorfs}, ...
%       emap.ut.scorematL.data < -3 );
%

function print_cytoscape_network (filename, nats, kans, criteria, ...
    edge_attribute_names, edge_attributes)
    if (nargin < 4)
        fprintf(['USAGE: filename, rowlabels, collabels,'...
            ' criteria, edge_att_names = {''a'',etc.}, '...
            'edge_atts = cat(3,etc.)\n']);
        return
    end
    
    if (length(nats)==2 && iscell(nats{1}) ...
            && length(kans)==2 && iscell(kans{1}))
        % Use both sets of labels
        twonames = 1;
        Nnat = length(nats{1});
        Nkan = length(kans{1});

    else
        twonames = 0;
        Nnat = length(nats);
        Nkan = length(kans);
    end
    
    if (nargin < 5)
        edge_attribute_names = {};
        edge_attributes = {};
    end
    
    file = fopen(filename,'wt');
    
    if (twonames)
        fprintf(file, 'gene1\torf1\tintType\tgene2\torf2');

    else
        fprintf(file, 'gene1\tintType\tgene2');

    end
    if (nargin > 4)
        fprintf(file, '\t%s', edge_attribute_names{:});
        
    end
    fprintf(file,'\n');
    
    for a = 1 : Nnat
        for b = 1 : Nkan
            if (criteria(a,b))

                if (twonames)
                    fprintf(file, '%s\t%s\tgg\t%s\t%s', ...
                        nats{1}{a}, nats{2}{a}, kans{1}{b}, kans{2}{b});
                else
                    fprintf(file, '%s\tgg\t%s', nats{a}, kans{b});
                end
                
                pos = sub2ind(size(criteria),a,b);
                fprintf(file, '\t%f', ...
                    cellfun(@(x)(in(x,pos)),edge_attributes));
                
                fprintf(file,'\n');

            end
        end
    end
    fclose(file);

end % of print_cytoscape_file


