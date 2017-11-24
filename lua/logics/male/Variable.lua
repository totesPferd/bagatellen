local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

package.loaded["logics.male.Variable"] =  Variable
local ValueStore =  require "logics.male.ValueStore"

function Variable:new()
   local retval =  self:__new()
   retval.value_store =  ValueStore:new()
   return retval
end

function Variable:copy()
   return self.__index:new()
end

function Variable:get_value_store()
   return self.value_store
end

function Variable:get_variable_cast()
   return self
end

function Variable:get_val()
   return self:get_value_store():get_val()
end

function Variable:set_val(val)
   local other_var =  val:get_variable_cast()
   if other_var
   then
      self.value_store =  other_var:get_value_store()
   else
      self.value_store:set_val(val)
   end
end

function Variable:__eq(other)
   local other_variable =  other:get_variable_cast()
   if self:get_value_store() == other_variable:get_value_store()
   then
      return true
   end

   local this_val =  self:get_val()
   local other_val =  other:get_val()
   return this_val and other_val and this_val == other_val
end

function Variable:devar(var_assgnm)
   local val =  var_assgnm:deref(self)
   if val
   then
      return val
   else
      local new_var
      val =  self:get_val()
      if val
      then
         new_var =  val:devar(var_assgnm)
      else
         new_var =  self:copy()
      end
      var_assgnm:add(self, new_var)
      return new_var
   end
end

return Variable
