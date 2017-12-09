local Variable =  require "logics.male.Variable"
local MetaVariable =  Variable:__new()

package.loaded["logics.male.MetaVariable"] =  MetaVariable

function MetaVariable:new()
   return Variable.new(self)
end

function MetaVariable:new_instance()
   return self.__index:new()
end

function MetaVariable:is_settable(var_ctxt)
   local this_val =  self:get_val()
   if this_val
   then
      return false
   else
      return true
   end
end

function MetaVariable:push_val(var)
   local retval
   local this_val =  self:get_val()
   if this_val
   then
      retval =  var:set_val(self:get_val())
   else
      retval =  self:set_val(var)
   end
   return retval
end

return MetaVariable
