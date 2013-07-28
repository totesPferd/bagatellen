local bindings_redland_module =  require "bindings.redland"
local Node     =  require "redland.Node"

local UriNode =  Node:__new()

package.loaded["redland.UriNode"] =  UriNode
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"


function UriNode:bindings_node_factory(bindings_node, uri_data)
   local retval =  UriNode:__new()
   retval.bindings_node =  bindings_node
   retval.uri_data =  uri_data
   return retval
end

function UriNode:new(world, uri)
   local bindings_uri =  uri:get_bindings_uri()
   local bindings_node =  redland_module.node.new_resource(world, bindings_uri)
   uri =  redland_module.node.get_resource(bindings_node)
   return self:bindings_node_factory(bindings_node, bindings_uri)
end

function UriNode:get_uri_node()
   return self
end

function UriNode:get_uri()
   return self.uri_data:get_bindings_uri()
end

function UriNode:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(redland.UriNode "
      .. self:get_uri():__tostring()
      .. ")" ))
end

function UriNode:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(redland.UriNode"))
   indentation:insert_newline()
   do
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      deeper_indentation:insert(String:string_factory(self:get_uri():__tostring()))
      deeper_indentation:insert(String:string_factory(" )"))
      deeper_indentation:save()
   end
end

return UriNode
