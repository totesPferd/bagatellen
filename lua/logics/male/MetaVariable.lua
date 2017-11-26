local Variable =  require "logics.male.Variable"

local MetaVariable =  Variable:__new()

package.loaded["logics.male.MetaVariable"] =  MetaVariable

function MetaVariable:new()
   local retval =  Variable.new(self)
   return retval
end

function MetaVariable:get_meta_variable_cast()
   return self
end

function MetaVariable:get_object_variable_cast()
end

function MetaVariable:get_backup()
   return { self:is_bound(), self:get_val() }
end

function MetaVariable:restore(backup)
   if backup
   then
      local bound_switch, val =  unpack(backup)
      self:set_bound_switch_direct(bound_switch)
      self:set_val_direct(val)
   end
end

function MetaVariable:finish(term)
   retval =  false
   if not term:is_bound()
   then
      retval =  self:push_val(term)
   end
   return retval
end

return MetaVariable
