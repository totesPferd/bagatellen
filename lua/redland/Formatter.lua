local bindings_redland_module =  require "bindings.redland"
local Type =  require "base.type.aux.Type"

local Formatter =  Type:__new()


package.loaded["redland.Formatter"] =  Formatter
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Formatter:bindings_formatter_factory(bindings_formatter)
   local retval =  Formatter:__new()
   retval.val =  bindings_formatter
   return retval
end

function Formatter:new(world, params)
   local mime_type
   if params.mime_type
   then
      mime_type =  params.mime_type:get_content()
   end
   local name
   if params.name
   then
      name =  params.name:get_content()
   end
   local bindings_uri
   if params.uri
   then
      bindings_uri =  params.uri:get_bindings_uri()
   end
   local bindings_formatter =  bindings_redland_module.results.new_formatter(
         world:get_bindings_world()
      ,  { mime_type =  mime_type, name =  name, uri = bindings_uri } )
   return(self:bindings_formatter_factory(bindings_formatter))
end

function Formatter:get_bindings_formatter()
   return self.val
end

function Formatter:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(redland::Formatter)" ))
end

function Formatter:__diagnose_multiple_line(indentation)
   return self:__diagnose_single_line(indentation)
end

return Formatter

