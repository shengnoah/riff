local element = require "elements"
buffer = function(tbl)
    local pcapdata=''
    for k,v in pairs(tbl) do
        pcapdata = pcapdata..string.char(v)
    end
    element:run(pcapdata)
end
