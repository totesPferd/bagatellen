local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

package.loaded["logics.male.Variable"] =  Variable
local String =  require "base.type.String"
local Unsettable =  require "logics.male.Unsettable"

function Variable:new()
   local retval =  self:__new()
   return retval
end

function Variable:new_unsettable()
   return Unsettable:new()
end

function Variable:copy()
   return self.__index:new()
end

function Variable:get_variable_cast()
   return self
end

function Variable:get_unsettable_cast()
end

function Variable:new_unsettable()
   return Unsettable:new()
end

function Variable:is_settable()
   local retval
   local this_val =  self:get_val()
   if this_val
   then
      retval =  false
   else
      retval =  true
   end
   return retval
end

function Variable:set_settable()
   local this_val =  self:get_val()
   if this_val
   then
      this_val:set_settable_switch(true)
   else
      self.val =  nil
   end
end

function Variable:set_unsettable()
   local this_val =  self:get_val()
   if this_val
   then
      this_val:set_settable_switch(false)
   else
      local next_unsettable =  self:new_unsettable()
      self.val =  next_unsettable
   end
end

function Variable:set_settable_switch(mode)
   if mode
   then
      self:set_settable()
   else
      self:set_unsettable()
   end
end

function Variable:get_val()
   return self.val
end

function Variable:set_val(val)
   local retval =  self:is_settable()
   if retval
   then
      self.val =  val
   end
   return retval
end

function Variable:push_val(var)
   return var:set_val(self:get_val())
end

function Variable:push_unsettable(unsettable)
   local retval =  false
   local this_val =  self:get_val()
   if this_val
   then
      retval =  this_val:push_unsettable(unsettable)
   end
   return retval
end

function Variable:equate(other)
   local retval =  false
   local this_val =  self:get_val()
   if this_val
   then
      retval =  this_val:equate(other)
   elseif self == other
   then
      retval =  true
   else
      retval =  other:push_val(self)
   end
   return retval
end

function Variable:val_eq(other)
   local retval =  self == other
   if not retval
   then
      local this_val =  self:get_val()
      local other_val =  other:get_val()
      retval =  this_val and other_val and this_val:val_eq(other_val)
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
      end
      if not new_var
      then
         new_var =  self:copy()
      end
      var_assgnm:add(self, new_var)
      return new_var
   end
end

return Variable
