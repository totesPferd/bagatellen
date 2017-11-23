local Variable =  require "logics.male.Variable"

local MetaVariable =  Variable:__new()

package.loaded["logics.male.MetaVariable"] =  MetaVariable

function MetaVariable:new()
   local retval =  Variable.new(self)
   return retval
end

function MetaVariable:get_variable_cast()
   return self:get_meta_variable_cast()
end

function MetaVariable:get_meta_variable_cast()
   return self
end

function MetaVariable:get_object_variable_cast()
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_object_variable_cast()
   end
end

function MetaVariable:get_backup()
   return self:get_val()
end

function MetaVariable:restore(val)
   self:set_val(val)
end

function MetaVariable:finish(term)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val == term:get_val()
   else
      self:set_val(term)
      return true
   end
end

function MetaVariable:equate(other)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:equate(other)
   else
      self:set_val(other)
      return true
   end
end

return MetaVariable
