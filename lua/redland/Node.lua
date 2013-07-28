local bindings_redland_module =  require "bindings.redland"
local Type =  require "base.type.aux.Type"

local Node =  Type:__new()

package.loaded["redland.Node"] =  Node
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

local BlankNode   =  require "redland.BlankNode"
local LiteralNode =  require "redland.LiteralNode"
local UriNode     =  require "redland.UriNode"

function Node:bindings_node_factory(bindings_node)
   local blank_data =  bindings_redland_module.node.get_blank(bindings_node)
   if blank_data
   then
      return BlankNode:bindings_node_factory(bindings_node, blank_data)
   end

   local literal_data =  bindings_redland_module.node.get_literal(bindings_node)
   if literal_data
   then
      return LiteralNode:bindings_node_factory(bindings_node, literal_data)
   end

   local uri_data =  bindings_redland_module.node.get_resource(bindings_node)
   if uri_data
   then
      return UriNode:bindings_node_factory(bindings_node, uri_data)
   end
end

function Node:get_bindings_node()
   return self.bindings_node
end

function Node:get_blank_node()
end

function Node:get_literal_node()
end

function Node:get_uri_node()
end

function Node:__clone()
   return bindings_node_factory(
         bindings_redland_module.node.__clone(self:get_bindings_node()) )
end

return Node
