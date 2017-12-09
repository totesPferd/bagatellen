local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

package.loaded["logics.male.Variable"] =  Variable
local String =  require "base.type.String"

function Variable:new()
   local retval =  self:__new()
   return retval
end

function Variable:copy()
   return self.__index:new()
end

function Variable:get_variable_cast()
   return self
end

function Variable:is_settable(var_ctxt)
   local retval
   local this_val =  self:get_val()
   if this_val
   then
      retval =  false
   else
      retval =  not var_ctxt:is_in(self)
   end
   return retval
end

function Variable:get_val()
   return self.val
end

function Variable:get_val_rec()
   local retval =  self
   local this_val =  self:get_val()
   if this_val
   then
      retval =  this_val:get_val_rec()
   end
   return retval
end

function Variable:set_val(var_ctxt, val)
   local retval =  self:is_settable(var_ctxt)
   if retval
   then
      self.val =  val
   end
   return retval
end

function Variable:push_val(var_ctxt, var)
   local retval
   local this_val =  self:get_val()
   if this_val
   then
      retval =  var:set_val(var_ctxt, self:get_val())
   else
      retval =  var:set_val(var_ctxt, self)
   end
   return retval
end

function Variable:equate(var_ctxt, other)
   local retval =  false
   local this_val =  self:get_val()
   local this_val_rec =  self:get_val_rec()
   local other_val_rec =  other:get_val_rec()
   if this_val
   then
      retval =  this_val_rec:equate(var_ctxt, other_val_rec)
   elseif self == other_val_rec
   then
      retval =  true
   else
      retval =  other_val_rec:push_val(var_ctxt, self)
   end
   return retval
end

function Variable:val_eq(other)
   local retval =  false
   if other
   then
      local this_val_rec =  self:get_val_rec()
      local other_val_rec =  other:get_val_rec()
      local this_val_rec_var =  this_val_rec:get_variable_cast()
      if this_val_rec_var
      then
         retval =  self_val_rec_var == other_val_rec_var
      else
         retval =  self_val_rec:val_eq(other_val_rec)
      end
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
