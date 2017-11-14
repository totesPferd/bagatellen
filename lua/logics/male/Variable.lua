local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

package.loaded["logics.male.Variable"] =  Variable

function Variable:new()
   local retval =  self:__new()
   return retval
end

function Variable:get_meta_variable()
end

function Variable:get_variable()
   return self
end

function Variable:be_a_variable(variable)
end

function Variable:get_val()
   if self.val
   then
      return self.val:get_val()
   end
end

function Variable:set_val(val)
   local this_val =  self:get_val()
   if this_val
   then
      local variable =  this_val:get_variable()
      if variable
      then
         variable:set_val(val)
      end
   else
      self.val =  val
   end
end

function Variable:equate(val)
   val:be_a_variable(val)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:equate(val)
   elseif self == val
   then
      return true
   else
      self:set_val(val)
      return true
   end
end

function Variable:devar(var_assgnm)
   local val =  var_assgnm:deref(self)
   if val
   then
      return val
   else
      val =  self:get_val()
      local new_var
      if val
      then
         local new_var =  val:devar(var_assgnm)
      else
         local new_var =  self:new()
      end
      var_assgnm:add(self, new_var)
      return new_var
   end
end

return Variable
