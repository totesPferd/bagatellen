local Type =  require "base.type.aux.Type"

local ObjectVariable =  Type:__new()

package.loaded["logics.ql.ObjectVariable"] =  ObjectVariable
local Constant =  require "logics.ql.Constant"
local MALEObjectVariable =  require "logics.male.ObjectVariable"
local QualifierObjectVariable =  require "logics.qualifier.ObjectVariable"

function ObjectVariable:new(qualifier, male_variable)
   local retval =  self:__new()
   retval.qualifier =  qualifier
   retval.male_variable
      =  male_variable or MALEObjectVariable:new()
   return retval
end

function ObjectVariable:new_instance(qualifier)
   return self.__index:new(qualifier, self:get_male_variable())
end

function ObjectVariable:new_constant(qualifier, symbol)
  return Constant:new(qualifier, symbol)
end

function ObjectVariable:get_qualifier()
   return self.qualifier
end

function ObjectVariable:get_male_variable()
   return self.male_variable
end

function ObjectVariable:get_variable_cast()
end

function ObjectVariable:get_constant_cast()
end

function ObjectVariable:equate(other)
   local this_male_val =  self:get_male_variable():get_val()
   if this_male_val
   then
      return this_male_val:equate(other)
   else
      local dev_lhs_qual, dev_rhs_qual
         =  self:get_qualifier():get_rhs_chopped_copy(other:get_qualifier())
      if dev_lhs_qual
      then
         local new_val =  other:new_instance(dev_lhs_qual)
         self:get_male_variable():set_val(new_val)
         return true
      else
         return false
      end
   end
end

function ObjectVariable:get_lhs_chop_constant(constant)
   local this_male_val =  self:get_male_variable():get_val()
   if this_male_val
   then
      local new_symbol
         =  this_male_val:get_constant_cast():get_symbol()
      local new_qual
         =  self:get_qualifier()
      local new_constant
         =  self:new_constant(new_qual, new_symbol)
      return new_constant:get_lhs_chop_constant(constant)
   end
end

function ObjectVariable:devar(var_assgnm)
   local dev_male =  self:get_male_variable():devar(var_assgnm)
   local dev_qual =  self:get_qualifier():devar(var_assgnm)
   return self.__index:new(dev_qual, dev_male)
end

return ObjectVariable
