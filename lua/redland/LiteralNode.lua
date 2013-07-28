local bindings_redland_module =  require "bindings.redland"
local Node     =  require "redland.Node"

local LiteralNode =  Node:__new()

package.loaded["redland.LiteralNode"] =  LiteralNode
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"
local Uri =  require "redland.Uri"


function LiteralNode:bindings_node_factory(bindings_node, literal_data)
   local retval =  LiteralNode:__new()
   retval.bindings_node =  bindings_node
   retval.literal_data =  literal_data
   return retval
end

function LiteralNode:new(world, literal_data)
   local bindings_node =  bindings_redland_module.node.new_literal(
         world:get_bindings_world()
      ,  literal_data )
   self.literal_data
      =  bindings_redland_module.node.get_literal(bindings_node)
   return self:bindings_node_factory(bindings_node, literal_data)
end

function LiteralNode:get_literal_node()
   return self
end

function LiteralNode:get_value()
   return self.literal_data.value
end

function LiteralNode:get_type()
   if self.literal_data.type
   then
      return Uri:bindings_uri_factory(self.literal_data.type)
   end
end

function LiteralNode:get_language()
   return self.literal_data.language
end

function LiteralNode:is_wf_xml()
   return self.literal_data.is_wf_xml
end

function LiteralNode:__tostring()
   local retval =  ""
   retval =  retval .. "value = " .. self:get_value()

   local type =  self:get_type()
   if type
   then
      retval =  retval .. ", type = " .. self:get_type():__tostring()
   end

   local language =  self:get_language()
   if language
   then
      retval =  retval .. ", language = " .. self:get_language()
   end

   local is_there_wf_xml =  self:is_wf_xml() ~= nil
   if is_there_wf_xml
   then
      retval =  retval .. ", is_wf_xml = " .. tostring(self:is_wf_xml())
   end

   return retval
end

function LiteralNode:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(redland.LiteralNode "
      .. self:__tostring()
      .. ")" ))
end

function LiteralNode:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(redland.LiteralNode"))
   indentation:insert_newline()
   do
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      deeper_indentation:insert(String:string_factory(self:__tostring()))
      deeper_indentation:insert(String:string_factory(" )"))
      deeper_indentation:save()
   end
end

return LiteralNode
