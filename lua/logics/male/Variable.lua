local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

package.loaded["logics.male.Variable"] =  Variable
local ValueStore =  require "logics.male.ValueStore"
local String =  require "base.type.String"

function Variable:new()
   local retval =  self:__new()
   retval.bound_switch =  false
   retval.value_store =  ValueStore:new()
   return retval
end

function Variable:copy()
   return self.__index:new()
end

function Variable:get_variable_cast()
   return self
end

function Variable:get_value_store()
   return self.value_store
end

function Variable:set_value_store(val)
   self.value_store =  val
end

function Variable:get_val()
   return self:get_value_store():get_val()
end

function Variable:get_bound_val()
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_bound_val()
   end
end

function Variable:set_val_direct(val)
   self:get_value_store():set_val(val)
end

function Variable:set_val(val)
   self:set_val_direct(val)
   self:set_bound()
end

function Variable:is_bound()
   return self.bound_switch
end

function Variable:set_bound_switch_direct(val)
   self.bound_switch =  val
end

function Variable:set_bound()
   self:set_bound_switch_direct(true)
end

function Variable:equate(other)
   local retval
   local this_val =  self:get_bound_val()
   if this_val
   then
      retval =  this_val:equate(other)
   else
      retval =  other:finish(self)
   end
   return retval
end

function Variable:__eq(other)
   local other_variable =  other:get_variable_cast()
   if self:get_value_store() == other_variable:get_value_store()
   then
      return true
   end

   local this_val =  self:get_bound_val()
   local other_val =  other:get_bound_val()
   return this_val and other_val and this_val == other_val
end

function Variable:devar(var_assgnm)
   local val =  var_assgnm:deref(self)
   if val
   then
      return val
   else
      local new_var
      val =  self:get_bound_val()
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
