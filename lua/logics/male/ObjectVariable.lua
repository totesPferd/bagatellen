local Variable =  require "logics.male.Variable"

local ObjectVariable =  Variable:__new()

package.loaded["logics.male.ObjectVariable"] =  ObjectVariable

function ObjectVariable:new()
   local retval =  Variable.new(self)
   return retval
end

function ObjectVariable:get_variable_cast()
   return self:get_object_variable_cast()
end

function ObjectVariable:get_meta_variable_cast()
end

function ObjectVariable:get_object_variable_cast()
   return self
end

function ObjectVariable:equate(val)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:equate(val)
   elseif self == val
   then
      return true
   else
      self:set_val(val)
      return true
   end
end

return ObjectVariable
