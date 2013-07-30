local bindings_redland_module =  require "bindings.redland"
local Type =  require "base.type.aux.Type"

local Parser =  Type:__new()


package.loaded["redland.Parser"] =  Parser
local Indentation =  require "base.Indentation"
local Node =  require "redland.Node"
local Stream =  require "redland.Stream"
local String =  require "base.type.String"
local Uri =  require "redland.Uri"

function Parser:bindings_parser_factory(bindings_parser)
   local retval =  Parser:__new()
   retval.val =  bindings_parser
   return retval
end

function Parser:get_bindings_parser()
   return self.val
end

function Parser:get_accept_header()
   return String:string_factory(bindings_redland_module.parser.get_accept_header(self:get_bindings_parser()))
end

function Parser:get_feature(uri)
   return Node:bindings_node_factory(bindings_redland_module.parser.get_feature(
         self:get_bindings_parser()
      ,  uri:get_bindings_uri() ))
end

function Parser:get_namespaces_seen_count()
   return bindings_redland_module.parser.get_namespaces_seen_count(
         self:get_bindings_parser() )
end

function Parser:get_namespaces_seen_prefix(offset)
   local raw_string bindings_redland_module.parser.get_namespaces_seen_prefix(
         self:get_bindings_parser()
      ,  offset )
   if raw_string
   then
      return String:string_factory(raw_string)
   end
end

function Parser:get_namespaces_seen_uri(offset)
   return Uri:bindings_uri_factory(bindings_redland_module.parser.get_namespaces_seen_uri(
         self:get_bindings_parser()
      ,  offset ))
end

function Parser.is_there_parser(world, name)
   return bindings_redland_mdoule.parser.is_ther_parser(
         world:get_bindings_world()
      ,  name:get_content() )
end

function Parser:new(world, params)
   local name
   if params.name
   then
      name =  params.name:get_content()
   end

   local mime_type
   if params.mime_type
   then
      mime_type =  params.mime_type:get_content()
   end

   local type_uri
   if param.type_uri
   then
      type_uri =  params.type_uri:get_bindings_uri()
   end

   return self:bindings_parser_factory(bindings_redland_module.parser.new(
         world:get_bindings_world()
      ,  { name = name, mime_type = mime_type, type_uri = type_uri } ))
end

function Parser:parse(uri, model, params)
   local base_uri
   if params.base_uri
   then
      base_uri =  params.base_uri:get_bindings_uri()
   end

   return bindings_redland_module.parser.parse(
         self:get_bindings_parser()
      ,  uri:get_bindings_uri()
      ,  model:get_bindings_model()
      ,  { base_uri = base_uri } )
end

function Parser:parse_string(model, content, params)
   local base_uri
   if params.base_uri
   then
      base_uri =  params.base_uri:get_bindings_uri()
   end

   return bindings_redland_module.parser.parse_string(
         self:get_bindings_parser()
      ,  model:get_bindings_model()
      ,  content:get_content()
      ,  { base_uri = base_uri } )
end

function Parser:set_feature(uri, node)
   return bindings_redland_module.parser.set_feature(
         self:get_bindings_parser()
      ,  uri:get_bindings_uri()
      ,  node:get_bindings_node() )
end

function Parser:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(redland.Parser)" ))
end

function Parser:__diagnose_multiple_line(indentation)
   return self:__diagnose_single_line(indentation)
end

return Parser

