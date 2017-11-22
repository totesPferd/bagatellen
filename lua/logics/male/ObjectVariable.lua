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

function ObjectVariable:get_backup()
end

function ObjectVariable:restore(val)
end

function ObjectVariable:equate(val)
   local retval =  true
   local backup =  val:get_backup()
   local this_val =  self:get_val()
   if this_val
   then
      retval =  this_val:equate(val)
      if not retval
      then
         val:restore(backup)
      end
   elseif self ~= val
   then
      self:set_val(val)
   end
   return retval
end

return ObjectVariable
