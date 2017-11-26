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
   return { self:get_val() }
end

function MetaVariable:restore(backup)
   if backup
   then
      local val =  unpack(backup)
      self:set_val(val)
   end
end

function MetaVariable:get_object_variable()
   return self.object_variable
end

function MetaVariable:set_object_variable(val)
   self.object_variable =  val
end

function MetaVariable:get_bound_val()
   local this_object_variable =  self:get_object_variable()
   if this_object_variable
   then
      return this_object_variable:get_bound_val()
   end
end

function MetaVariable:push_val(var)
   local retval
   local this_val =  self:get_val()
   if this_val
   then
      retval =  this_val:push_val(var)
   else
      retval =  self:set_object_variable(var)
   end
   return retval
end

return MetaVariable
