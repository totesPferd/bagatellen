local Type =  require "base.type.aux.Type"

local MetaVariable =  Type:__new()

package.loaded["logics.male.MetaVariable"] =  MetaVariable

function MetaVariable:new()
   local retval =  self:__new()
   return retval
end

function MetaVariable:get_meta_variable()
   return self
end

function MetaVariable:get_variable()
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_variable()
   end
end

function MetaVariable:be_a_variable(variable)
   local this_val =  self:get_val()
   if not this_val
   then
      self:set_val(variable)
   end
end

function MetaVariable:get_val()
   if self.val
   then
      local var =  self.val:get_variable()
      if var
      then
         return var:get_val()
      else
         return self.val
      end
   end
end

function MetaVariable:set_val(val)
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

-- undefined; by definition as division by zero is undefined!!!
function MetaVariable:equate(val)
end

function MetaVariable:devar(var_assgnm)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:devar(var_assgnm)
   else
      return self
   end
end

return MetaVariable
