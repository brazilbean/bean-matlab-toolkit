% Gordon Bean, December 2010

function genes = orf2gene ( orfs, convert )
    referencefile = 'GENE_ORF.tab';
    if (nargin < 2)
        % Use default reference;
        genes = translate( referencefile, orfs, 2, 1 );
    else
        if (isstruct( convert))
            % Use original method for EMAP Toolkit structs
            genes = orfs;
            gi = achar(orfs, convert.orfname, 1);

            genes(~isnan(gi)) = convert.genename(gi(~isnan(gi)));

        elseif (ischar( convert ))
            % Use convert as a reference file
            genes = translate( convert, orfs, 2, 1 );
            
        else
            % Fail
            error('Please provide a translation file or struct.');
        end
    end
    
end
