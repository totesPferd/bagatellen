local Type =  require "base.type.aux.Type"

local ObjectVariable =  Type:__new()

package.loaded["logics.male.ObjectVariable"] =  ObjectVariable

function ObjectVariable:new()
   local retval =  self:__new()
   return retval
end

function ObjectVariable:new_instance()
   return ObjectVariable:new()
end

function ObjectVariable:get_meta_variable()
end

function ObjectVariable:get_object_variable()
   return self
end

function ObjectVariable:be_an_object_variable(variable)
end

function ObjectVariable:get_val()
   if self.val
   then
      local var =  self.val:get_object_variable()
      if var
      then
         return var:get_val()
      else
         return self.val
      end
   end
end

function ObjectVariable:set_val(val)
   local other_var =  val:get_object_variable()
   if not (other_var and other_var == self)
   then
      local this_val =  self.val
      if this_val
      then
         local variable =  this_val:get_object_variable()
         if variable
         then
            variable:set_val(val)
         end
      else
         self.val =  val
      end
   end
end

function ObjectVariable:equate(val)
   val:be_an_object_variable(val)
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

function ObjectVariable:devar(var_assgnm)
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
         local new_var =  self:new_instance()
      end
      var_assgnm:add(self, new_var)
      return new_var
   end
end

return ObjectVariable
