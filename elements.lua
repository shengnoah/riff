local pipeline = require "pipeline"
local status = pipeline:new {
    require"plugin.source_plugin",
    require"plugin.filter_plugin",
}
return pipeline

