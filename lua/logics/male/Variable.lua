local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

package.loaded["logics.male.Variable"] =  Variable
local String =  require "base.type.String"

function Variable:new(settable)
   local retval =  self:__new()
   retval.settable_switch =  settable or false
   return retval
end

function Variable:copy()
   return self.__index:new(true)
end

function Variable:get_variable_cast()
   return self
end

function Variable:is_settable()
   local retval
   local this_val =  self:get_val()
   if this_val
   then
      retval =  false
   else
      retval =  self.settable_switch
   end
   return retval
end

function Variable:set_settable_switch(mode)
   local this_val =  self:get_val()
   if this_val
   then
      this_val:set_settable_switch(mode)
   else
      self.settable_switch =  mode
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
   local retval
   local this_val =  self:get_val()
   if this_val
   then
      retval =  var:set_val(self:get_val())
   else
      retval =  var:set_val(self)
   end
   return retval
end

function Variable:equate(other)
local s_a =  self:diagnose {}
local o_a =  other:diagnose {}
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
