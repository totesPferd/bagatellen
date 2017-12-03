local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

package.loaded["logics.male.Variable"] =  Variable
local MetaVariable =  require "logics.male.MetaVariable"
local String =  require "base.type.String"

function Variable:new()
   local retval =  self:__new()
   retval.settable_switch =  true
   return retval
end

function Variable:new_meta_variable()
   return MetaVariable:new()
end

function Variable:copy()
   return self.__index:new()
end

function Variable:get_variable_cast()
   return self
end

function Variable:is_settable()
   return self.settable_switch
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

function Variable:set_value_store(val)
   local retval =  self:is_settable()
   if retval and self:set_val(val)
   then
      val:set_settable_switch(false)
   end
   return retval
end

function Variable:push_val(var)
   local retval =  self == var
   if not retval
   then
      local next_meta_var =  self:new_meta_variable()
      self:set_val(next_meta_var)
      retval =  var:set_value_store(next_meta_var)
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
