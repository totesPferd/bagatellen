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
   local language_str
   if literal_data.language
   then
      language_str =  literal_data.language:get_content()
   end

   local bindings_type_uri
   if literal_data.type
   then
      bindings_type_uri =  literal_data.type:get_bindings_uri()
   end

   local value_str
   if literal_data.value
   then
      value_str =  literal_data.value:get_content()
   end

   local bindings_node =  bindings_redland_module.node.new_literal(
         world:get_bindings_world()
      ,  {
            is_wf_xml =  literal_data.is_wf_xml
         ,  language = language_str
         ,  type =  bindings_type_uri
         ,  value = value_str } )

   local raw_literal_data =  bindings_redland_module.node.get_literal(
         bindings_node )
   local re_literal_data =  {}
   if raw_literal_data.is_wf_xml
   then
      re_literal_data.is_wf_xml =  raw_literal_data.is_wf_xml
   end
   if raw_literal_data.language
   then
      re_literal_data.language =  String:string_factory(
            raw_literal_data.language )
   end
   if raw_literal_data.type
   then
      re_literal_data.type =   Uri:bindings_uri_factory(
         raw_literal.type )
   end
   if raw_literal_data.value
   then
      re_literal_data.value =  String:string_factory(
            raw_literal_data.value )
   end
   return self:bindings_node_factory(bindings_node, re_literal_data)
end

function LiteralNode:get_literal_node()
   return self
end

function LiteralNode:get_value()
   return self.literal_data.value
end

function LiteralNode:get_type()
   return self.literal_data.type
end

function LiteralNode:get_language()
   return self.literal_data.language
end

function LiteralNode:is_wf_xml()
   return self.literal_data.is_wf_xml
end

function LiteralNode:__tostring()
   local retval =  ""
   local value =  self:get_value()
   if value
   then
      retval =  retval .. "value = " .. value
   end

   local type =  self:get_type()
   if type
   then
      retval =  retval .. ", type = " .. type:__tostring()
   end

   local language =  self:get_language()
   if language
   then
      retval =
            retval
         .. ", language = "
         .. language:get_content()
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
