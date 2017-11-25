local Variable =  require "logics.male.Variable"

local ObjectVariable =  Variable:__new()

package.loaded["logics.male.ObjectVariable"] =  ObjectVariable

function ObjectVariable:new()
   local retval =  Variable.new(self)
   return retval
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

function ObjectVariable:finish(term)
   local retval =  true
   local this_value_store =  self:get_value_store()
   if
         this_value_store ~= term:get_value_store()
     and term:is_bound()
   then
      retval =  false
   else
      term:set_value_store(this_value_store)
      term:set_bound()
   end
   return retval
end

function ObjectVariable:equate(other)
   local retval =  true
   local this_val =  self:get_val()
   if this_val
   then
      retval =  this_val:equate(other)
   else
      retval =  other:finish(self)
   end
   return retval
end

return ObjectVariable
