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
   local retval =  false
   local this_value_store =  self:get_value_store()
   if this_value_store == term:get_value_store()
   then
      retval =  true
   elseif not term:is_bound()
   then
      term:set_value_store(this_value_store)
      term:set_bound()
      retval =  true
   end
   return retval
end

return ObjectVariable
