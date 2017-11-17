local Variable =  require "logics.male.Variable"

local ObjectVariable =  Variable:__new()

package.loaded["logics.male.ObjectVariable"] =  ObjectVariable

function ObjectVariable:new()
   local retval =  Variable.new(self)
   return retval
end

function ObjectVariable:new_instance()
   return ObjectVariable:new()
end

function ObjectVariable:get_variable()
   return self:get_object_variable()
end

function ObjectVariable:get_meta_variable()
end

function ObjectVariable:get_object_variable()
   return self
end

function ObjectVariable:be_an_object_variable(variable)
end

function ObjectVariable:equate(val)
   val:be_an_object_variable(self)
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
