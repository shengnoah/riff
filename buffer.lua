buffer = function(tbl)
    local tmpstr=''
    for k,v in pairs(tbl) do
        tmpstr = tmpstr..string.char(v)
    end
    io.write(tmpstr,"\n")
end
