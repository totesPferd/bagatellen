local bindings_redland_module =  require "bindings.redland"
local Node     =  require "redland.Node"

local BlankNode =  Node:__new()

package.loaded["redland.BlankNode"] =  BlankNode
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"


function BlankNode:bindings_node_factory(bindings_node, blank_data)
   local retval =  BlankNode:__new()
   retval.bindings_node =  bindings_node
   retval.blank_data =  blank_data
   return retval
end

function BlankNode:new(world, id_string)
   local blank_data =  {}
   if id_string
   then
      blank_data.id =  id_string
   end
   local bindings_node =  redland_module.node.new_blank(world, blank_data)
   blank_data =  redland_module.node.get_blank(bindings_node)
   return self:bindings_node_factory(bindings_node, blank_data)
end

function BlankNode:get_blank_node()
   return self
end

function BlankNode:get_id()
   return self.blank_data.id
end

function BlankNode:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(redland.BlankNode "
      .. self:get_id()
      .. ")" ))
end

function BlankNode:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(redland.BlankNode"))
   indentation:insert_newline()
   do
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      deeper_indentation:insert(String:string_factory(self:get_id()))
      deeper_indentation:insert(String:string_factory(" )"))
      deeper_indentation:save()
   end
end

return BlankNode
