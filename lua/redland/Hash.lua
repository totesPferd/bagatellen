local redland_module =  require "bindings.redland"
local Type =  require "base.type.aux.Type"

local Hash =  Type:__new()


package.loaded["redland.Hash"] =  Hash
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Hash:bindings_hash_factory(bindings_hash)
   local retval =  Hash:__new()
   retval.val =  bindings_hash
   return retval
end

function Hash:get_bindings_hash()
   return self.val
end

function Hash:deref(key)
   local raw_result
      =  redland_module.hash.get(
            self:get_bindings_hash()
         ,  key:get_content() )
   if raw_result
   then
      return String:string_factory(raw_result)
   end
end

function Hash:get_boolean(key)
   return redland_module.hash.get_boolean(
         self:get_bindings_hash()
      ,  key:get_content() )
end

function Hash:get_del(key)
   return redland_module.hash.get_del(
         self:get_bindings_hash()
      ,  key:get_content() )
end

function Hash:get_long(key)
   return redland_module.hash.get_long(
         self:get_bindings_hash()
      ,  key:get_content() )
end

function Hash:init(init)
   redland_module.hash.init(
         self:get_bindings_hash()
      ,  init:get_content() )
end

function Hash:add(key, val)
   redland_module.hash.insert(
         self:get_bindings_hash()
      ,  key:get_content()
      ,  val:get_content() )
end

function Hash:interpret(template, prefix, suffix)
   local raw_result =  redland_module.hash.interpret(
         self:get_bindings_hash()
      ,  template:get_content()
      ,  prefix:get_content()
      ,  suffix:get_content() )
   if raw_result
   then
      return String:string_factory(raw_result)
   end
end

function Hash:new(world, name)
   return Hash:bindings_hash_factory(redland_module.hash.new(
         world:get_bindings_world()
      ,  name:get_content() ))
end

function Hash:new_from_string(work, name, options)
   return Hash:bindings_hash_factory(redland_module.hash.new_from_string(
         world:get_bindings_world()
      ,  name:get_content()
      ,  options:get_content() ))
end

function Hash:__clone()
   return Hash:bindings_hash_factory(
      redland_module.hash.__clone(self:get_bindings_hash()) )
end

function Hash:drop(key)
   self:get_del(key)
end

function Hash:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(redland::Hash)"))
end

function Hash:__diagnose_multiple_line(indentation)
   return self:__diagnose_single_line(indentation)
end

return Hash
