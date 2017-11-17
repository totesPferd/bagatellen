local Variable =  require "logics.male.Variable"

local MetaVariable =  Variable:__new()

package.loaded["logics.male.MetaVariable"] =  MetaVariable

function MetaVariable:new()
   local retval =  Variable.new(self)
   return retval
end

function MetaVariable:get_meta_variable()
   return self
end

function MetaVariable:get_object_variable()
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_object_variable()
   end
end

function MetaVariable:be_an_object_variable(variable)
   local this_val =  self:get_val()
   if not this_val
   then
      self:set_val(variable)
   end
end

-- undefined; by definition as division by zero is undefined!!!
function MetaVariable:equate(val)
end

return MetaVariable
