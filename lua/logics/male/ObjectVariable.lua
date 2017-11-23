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

function ObjectVariable:finish(val)
   return self ~= val
end

function ObjectVariable:equate(other)
   local retval =  true
   local backup =  other:get_backup()
   local this_val =  self:get_val()
   if this_val
   then
      retval =  this_val:equate(other)
      if not retval
      then
         other:restore(backup)
      end
   elseif other:finish(self)
   then
      self:set_val(other)
   else
      retval =  false
   end
   return retval
end

return ObjectVariable
