local Type =  require "base.type.aux.Type"

local Variable =  Type:__new()

package.loaded["logics.male.Variable"] =  Variable
local Generic =  require "logics.male.base_variable_copier.Generic"
local ValueStore =  require "logics.male.ValueStore"

function Variable:new()
   local retval =  self:__new()
   retval.value_store =  ValueStore:new()
   return retval
end

function Variable:get_base_variable_copier()
   return Generic
end

function Variable:get_value_store()
   return self.value_store
end

function Variable:get_variable()
   return self
end

function Variable:get_val()
   return self:get_value_store():get_val()
end

function Variable:set_val(val)
   local other_var =  val:get_variable()
   if other_var
   then
      self.value_store =  val:get_value_store()
   else
      self.value_store:set_val(val)
   end
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
         new_var =  self:get_base_variable_copier():new()
      end
      var_assgnm:add(self, new_var)
      return new_var
   end
end

