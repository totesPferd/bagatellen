local Variable =  require "logics.male.Variable"
local MetaVariable =  Variable:__new()

package.loaded["logics.male.MetaVariable"] =  MetaVariable

function MetaVariable:new()
   return Variable.new(self, true)
end

function MetaVariable:new_instance()
   return self.__index:new()
end

function MetaVariable:set_settable_switch(mode)
   local this_val =  self:get_val()
   if this_val
   then
      this_val:set_settable_switch(mode)
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
