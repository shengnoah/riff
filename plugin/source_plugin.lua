local source_plugin = {}
local src = {
   args="source args"
}

local sink = {
    name = "source_plugin",
    ver = "0.1"
}

function source_plugin.output(self, list, flg)
    if flg == 0 then
        return
    end

    for k,v in pairs(list) do
        print(k,v)
    end
end

function source_plugin.push(self, stream) 
    for k,v in pairs(stream.metadata) do
        self.source[k]=v
    end 
end

function  source_plugin.init(self)
    self.source = src
    self.sink = sink
end

function source_plugin.action(self, stream) 
end

function  source_plugin.match(self, param)
    self.sink['found_flg']=false
    for kn,kv in pairs(self.source) do
         self.sink[kn] = kv
    end
    self.sink['metadata'] = { data=self.source['data'] }
    self:action(self.sink)
    return self.source, self.sink
end

return  source_plugin
