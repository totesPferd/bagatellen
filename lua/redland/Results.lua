local bindings_redland_module =  require "bindings.redland"
local Type =  require "base.type.aux.Type"

local Results =  Type:__new()


package.loaded["redland.Results"] =  Results
local Indentation =  require "base.Indentation"
local Stream =  require "redland.Stream"
local String =  require "base.type.String"

function Results:bindings_results_factory(bindings_results)
   local retval =  Results:__new()
   retval.val =  bindings_results
   return retval
end

function Results:get_bindings_results()
   return self.val
end

function Results:get_boolean()
   return redland_module.results.get_boolean(
         self:get_bindings_results() )
end

function Results:is_binding()
   return redland_module.results.is_binding(
         self:get_bindings_results() )
end

function Results:is_boolean()
   return redland_module.results.is_boolean(
         self:get_bindings_results() )
end

function Results:is_finished()
   return redland_module.results.is_finished(
         self:get_bindings_results() )
end

function Results:is_graph()
   return redland_module.results.is_graph(
         self:get_bindings_results() )
end

function Results:is_syntax()
   return redland_module.results.is_syntax(
         self:get_bindings_results() )
end

function Results.is_there_formatter(world, mime_type, params)
   local name
   if params.name
   then
      name =  params.name.get_content()
   end
   local bindings_uri
   if params.uri
   then
      bindings_uri =  params.uri:get_bindings_uri()
   end
   return redland_module.results.is_there_formatter(
         world:get_bindings_world()
      ,  mime_type
      ,  { name =  name, uri =  bindings_uri })
end

function Results:next()
   return redland_module.results.next(
         self:get_bindings_results() )
end

function Results:__len()
   return redland_module.results.size(
         self:get_bindings_results() )
end

function Results:to_file(name, params)
   local base_bindings_uri
   if params.base
   then
      base_bindings_uri =  params.base:get_bindings_uri()
   end
   local mime_type
   if params.mime_type
   then
      mime_type =  params.mime_type:get_content()
   end
   local format_bindings_uri
   if params.format
   then
      format_bindings_uri =  params.format:get_bindings_uri()
   end

   return redland_module.results.to_file(
         self:get_bindings_results()
      ,  name
      ,  {  base =  base_bindings_uri, mime_type =  mime_type, format =  format_bindings_uri } )
end

function Results:to_stream()
   local raw_stream =  bindings_redland_module.results.to_stream(
         self:get_bindings_results() )
   if raw_stream
   then
      return Stream:bindings_stream_factory(raw_stream)
   end
end

function Results:to_string(name, params)
   local base_bindings_uri
   if params.base
   then
      base_bindings_uri =  params.base:get_bindings_uri()
   end
   local mime_type
   if params.mime_type
   then
      mime_type =  params.mime_type:get_content()
   end
   local format_bindings_uri
   if params.format
   then
      format_bindings_uri =  params.format:get_bindings_uri()
   end

   return String:string_factory(redland_module.results.to_file(
         self:get_bindings_results()
      ,  name
      ,  {  base =  base_bindings_uri, mime_type =  mime_type, format =  format_bindings_uri } ))
end

function Results:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(redland::Results)" ))
end

function Results:__diagnose_multiple_line(indentation)
   return self:__diagnose_single_line(indentation)
end

return Results

