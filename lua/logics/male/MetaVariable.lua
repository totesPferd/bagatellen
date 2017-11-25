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
   local this_val =  self:get_val()
   if this_val
   then
      return this_val == term:get_val()
   elseif self:is_bound()
   then
      return false
   else
      self:set_val_direct(term)
      self:set_bound()
      return true
   end
end

function MetaVariable:equate(other)
   local retval =  true
   local this_val =  self:get_val()
   if this_val
   then
      retval =  this_val:equate(other)
   else
      self:set_val(other)
   end
   return retval
end

return MetaVariable
