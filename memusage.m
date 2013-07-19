% Gordon Bean, December 2010

function usage = memusage (whostruct)
    
    doo = {whostruct.bytes};
    usage = 0;
    for d = 1 : length(doo)
        usage = usage + doo{d};
    end
    usage = usage / 1024 / 1024;
end