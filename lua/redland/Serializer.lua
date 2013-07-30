local bindings_redland_module =  require "bindings.redland"
local Type =  require "base.type.aux.Type"

local Serializer =  Type:__new()


package.loaded["redland.Serializer"] =  Serializer
local Indentation =  require "base.Indentation"
local Node =  require "redland.Node"
local Stream =  require "redland.Stream"
local String =  require "base.type.String"
local Uri =  require "redland.Uri"

function Serializer:bindings_serializer_factory(bindings_serializer)
   local retval =  Serializer:__new()
   retval.val =  bindings_serializer
   return retval
end

function Serializer:get_bindings_serializer()
   return self.val
end

function Serializer:get_feature(uri)
   return Node:bindings_node_factory(bindings_redland_module.serializer.get_feature(
         self:get_bindings_serializer()
      ,  uri:get_bindings_uri() ))
end

function Serializer.is_there_serializer(world, name)
   return bindings_redland_mdoule.serializer.is_ther_serializer(
         world:get_bindings_world()
      ,  name:get_content() )
end

function Serializer:new(world, params)
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
   if params.type_uri
   then
      type_uri =  params.type_uri:get_bindings_uri()
   end

   return self:bindings_serializer_factory(bindings_redland_module.serializer.new(
         world:get_bindings_world()
      ,  { name = name, mime_type = mime_type, type_uri = type_uri } ))
end

function Serializer:serialize_stream_to_file(stream, filename, params)
   local base_uri
   if params.base_uri
   then
      base_uri =  params.base_uri:get_bindings_uri()
   end

   return bindings_redland_module.serializer.serialize_stream_to_file(
         self:get_bindings_serializer()
      ,  stream:get_bindings_stream()
      ,  filename:get_content()
      ,  { base_uri = base_uri } )
end

function Serializer:serialize_stream_to_string(stream, params)
   local base_uri
   if params.base_uri
   then
      base_uri =  params.base_uri:get_bindings_uri()
   end

   return bindings_redland_module.serializer.parse_string(
         self:get_bindings_serializer()
      ,  stream:get_bindings_stream()
      ,  { base_uri = base_uri } )
end

function Serializer:serialize_to_file(model, filename, params)
   local base_uri
   if params.base_uri
   then
      base_uri =  params.base_uri:get_bindings_uri()
   end

   return bindings_redland_module.serializer.serialize_to_file(
         self:get_bindings_serializer()
      ,  model:get_bindings_model()
      ,  filename:get_content()
      ,  { base_uri = base_uri } )
end

function Serializer:serialize_to_string(model, params)
   local base_uri
   if params.base_uri
   then
      base_uri =  params.base_uri:get_bindings_uri()
   end

   return bindings_redland_module.serializer.parse_string(
         self:get_bindings_serializer()
      ,  model:get_bindings_model()
      ,  { base_uri = base_uri } )
end

function Serializer:set_feature(uri, node)
   local raw_string =  bindings_redland_module.serializer.set_feature(
         self:get_bindings_serializer()
      ,  uri:get_bindings_uri()
      ,  node:get_bindings_node() )
   if raw_string
   then
      return String:string_factory(raw_string)
   end
end

function Serializer:set_namespace(params)
   local prefix_string
   if params.prefix_string
   then
      prefix_string =  params.prefix_string:get_content()
   end

   local uri
   if params.uri
   then
      uri =  params.uri:get_bindings_uri()
   end

   return bindings_redland_module.serializer.set_namespace(
         self:get_bindings_serializer()
      ,  { prefix_string = prefix_string, uri = uri } )
end

function Serializer:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(redland.Serializer)" ))
end

function Serializer:__diagnose_multiple_line(indentation)
   return self:__diagnose_single_line(indentation)
end

return Serializer

