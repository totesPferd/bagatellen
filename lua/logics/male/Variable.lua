local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

package.loaded["logics.male.Variable"] =  Variable
local ValueStore =  require "logics.male.ValueStore"
local String =  require "base.type.String"

function Variable:new(settable)
   local retval =  self:__new()
   retval.value_store =  ValueStore:new(settable)
   return retval
end

function Variable:copy()
   return self.__index:new(true)
end

function Variable:get_variable_cast()
   return self
end

function Variable:get_value_store()
   return self.value_store
end

function Variable:is_settable()
   return self:get_value_store():is_settable()
end

function Variable:set_value_store(val)
   self.value_store =  val
end

function Variable:get_val()
   return self:get_value_store():get_val()
end

function Variable:get_bound_val()
   return self:get_val()
end

function Variable:set_val(val)
   return self:get_value_store():set_val(val)
end

function Variable:push_val(var)
   var:set_value_store(self:get_value_store())
   return true
end

function Variable:equate(other)
   local retval =  false
   local this_val =  self:get_bound_val()
   if this_val
   then
      retval =  this_val:equate(other)
   else
      retval =  other:push_val(self)
   end
   return retval
end

function Variable:__eq(other)
   local retval
   local other_variable =  other:get_variable_cast()
   if
         other_variable
     and self:get_value_store() == other_variable:get_value_store()
   then
      retval =  true
   else
      local this_val =  self:get_bound_val()
      local other_val =  other:get_bound_val()
      retval =  this_val and other_val and this_val == other_val
   end
   return retval
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
