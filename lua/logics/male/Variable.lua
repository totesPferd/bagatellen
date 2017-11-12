local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

package.loaded["logics.male.Variable"] =  Variable
local StringKeyDict =  require "base.type.dict.StringKey"

function Variable:new()
   local retval =  self:__new()
   retval.dict =  StringKeyDict:empty_dict_factory()
   return retval
end

function Variable:get_variable()
   return self
end

function Variable:get_val(dimension)
   return self.dict:deref(dimension)
end

function Variable:set_val(dimension, val)
   self.dict:add(dimension, val)
end

function Variable:equate(dimension, val)
   local this_val =  self:get_val(dimension)
   if this_val
   then
      return this_val:equate(dimension, val)
   elseif self == val
   then
      return true
   else
      self:set_val(dimension, val)
      return true
   end
end

function Variable:devar(dimension, var_assgnm)
   local val =  var_assgnm:deref(self)
   if val
   then
      return val
   else
      val =  self:get_val(dimension)
      local new_var
      if val
      then
         local new_var =  val:devar(dimension, var_assgnm)
      else
         local new_var =  self:new()
      end
      var_assgnm:add(self, new_var)
      return new_var
   end
end

return Variable
