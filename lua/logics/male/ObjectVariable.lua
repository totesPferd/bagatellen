local Variable =  require "logics.male.Variable"

local ObjectVariable =  Variable:__new()

package.loaded["logics.male.ObjectVariable"] =  ObjectVariable

function ObjectVariable:new()
   local retval =  Variable.new(self)
   return retval
end

function ObjectVariable:get_variable()
   return self:get_object_variable()
end

function ObjectVariable:get_meta_variable()
end

function ObjectVariable:get_object_variable()
   return self
end

function ObjectVariable:assign_object_variable_to_meta_variable(variable)
   return true
end

function ObjectVariable:equate(val)
   if val:assign_object_variable_to_meta_variable(self)
   then
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
end

return ObjectVariable
