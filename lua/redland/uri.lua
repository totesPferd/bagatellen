bindings_redland_module =  require "bindings.redland"
local Type =  require "base.type.aux.Type"

local Uri =  Type:__new()

package.loaded["redland.Uri"] =  Uri
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Uri:bindings_uri_factory(bindings_uri)
   local retval =  Uri:__new()
   retval.val =  bindings_uri
   return retval
end

function Uri:filename_factory(world, filename)
   local bindings_world =  world:get_bindings_world()
   local bindings_uri
      =  bindings_redland_module.uri.new_from_filename(
            bindings_world
         ,  filename )
   return self:bindings_uri_factory(bindings_uri)
end

function Uri:local_name_factory(uri, rel_string)
   local bindings_uri_arg =  uri:get_bindings_uri()
   local bindings_uri_res
      =  bindings_redland_module.uri.new_from_local_name(
            bindings_uri_arg
         ,  rel_string )
   return self:bindings_uri_factory(bindings_uri_res)
end

function Uri:normalized_to_base_factory(from_uri, to_uri, rel_string)
   local bindings_uri_from =  from_uri:get_bindings_uri()
   local bindings_uri_to   =  to_uri:get_bindings_uri_from()
   local bindings_uri_res
      =  bindings_redland_module.uri.new_normalized_to_base(
            bindings_uri_from
         ,  bindings_uri_to
         ,  rel_string )
   return self:bindings_uri_factory(bindings_uri_res)
end

function Uri:relative_to_base_factory(uri, rel_string)
   local bindings_uri_arg =  uri:get_bindings_uri()
   local bindings_uri_res
      =  bindings_redland_module.uri.new_relative_to_base(
            bindings_uri_arg
         ,  rel_string )
   return self:bindings_uri_factory(bindings_uri_res)
end

function Uri:new(world, uri_string)
   local bindings_world =  world:get_bindings_world()
   local bindings_uri =  bindings_redland_module.uri.new(
         bindings_world
      ,  uri_string )
   return self:bindings_uri_factory(bindings_uri)
end

function Uri:get_bindings_uri()
   return self.val
end

function Uri:__tostring()
   return tostring(self.val)
end

function Uri:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(redland.Uri "
      .. self:__tostring()
      .. ")" ))
end

function Uri:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(redland.Uri"))
   indentation:insert_newline()
   do
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      deeper_indentation:insert(String:string_factory(self:__tostring()))
      deeper_indentation:insert(String:string_factory(" )"))
      deeper_indentation:save()
   end
end

return Uri


