local Pipeline = {}
local Pobj = {}


function Pipeline.output(self, list, flg)
    if flg == 0 then
        return 
    end

    for k,v in pairs(list) do
        print(k,v)
    end
end

function Pipeline.new(self, elements)
    self.element_list = elements
    self:output(elements, 0)
    return PObj
end

function Pipeline.run(self, pcapdata)
    local src = {
        metadata= { 
            data= pcapdata,
            request = {
                uri="http://www.candylab.net"
            }
        }
    }
    for k,v in pairs(self.element_list) do
        v:init()
        v:push(src)
        local src, sink = v:match(pcapdata)
        if type(sink) == "table" then
            self:output(sink, 0)
        end
        src = sink
    end
end

return Pipeline

