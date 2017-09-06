local filter_plugin = {}
local src = {
   args="filter args"
}

local sink = {
    name = "filter_plugin",
    ver = "0.1"
}

function filter_plugin.output(self, list, flg)
    if flg == 0 then
        return
    end

    for k,v in pairs(list) do
        print(k,v)
    end
end

function filter_plugin.push(self, stream) 
    for k,v in pairs(stream.metadata) do
        self.source[k]=v
    end 
end

function  filter_plugin.init(self)
    self.source = src
    self.sink = sink
end

function filter_plugin.action(self, stream) 
    io.write(stream.data, "\n")
end

function  filter_plugin.match(self, param)
    self.sink['found_flg']=false
    for kn,kv in pairs(self.source) do
         self.sink[kn] = kv
    end
    self.sink['metadata'] = { data=self.source['data'] }
    self:action(self.sink)
    return self.source, self.sink
end

return  filter_plugin
