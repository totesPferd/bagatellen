local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

package.loaded["logics.male.Variable"] =  Variable
local ValueStore =  require "logics.male.ValueStore"
local String =  require "base.type.String"

function Variable:new(settable)
   local retval =  self:__new()
   retval.bound_switch =  false
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

function Variable:set_settable_switch(mode)
   local this_val =  self:get_val()
   if this_val
   then
      this_val:set_settable_switch(mode)
   else
      self:get_value_store():set_settable_switch(mode)
   end
end

function Variable:is_bound()
   local retval =  self.bound_switch
   if not retval
   then
      local this_val =  self:get_val()
      if this_val
      then
         retval =  true
      end
   end
   return retval
end
   
function Variable:set_value_store(val)
   local retval =  not self:is_bound() and self:is_settable()
   if retval
   then
      self.value_store =  val
      self.bound_switch =  true
   end
   return retval
end

function Variable:get_val()
   return self:get_value_store():get_val()
end

function Variable:set_val(val)
   return self:get_value_store():set_val(val)
end

function Variable:push_val(var)
   local retval =  self == var
   if not retval
   then
      retval =  var:set_value_store(self:get_value_store())
   end
   return retval
end

function Variable:equate(other)
   local retval =  false
   local this_val =  self:get_val()
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
      local this_val =  self:get_val()
      local other_val =  other:get_val()
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
