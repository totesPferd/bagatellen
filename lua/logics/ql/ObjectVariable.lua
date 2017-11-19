local Type =  require "base.type.aux.Type"

local ObjectVariable =  Type:__new()

package.loaded["logics.ql.ObjectVariable"] =  ObjectVariable
local QualifierObjectVariable =  require "logics.qualifier.ObjectVariable"

function ObjectVariable:new(qualifier, male_variable)
   local retval =  self:__new()
   retval.qualifier =  qualifier
   retval.male_variable
      =  male_variable or QualifierObjectVariable:new()
   return retval
end

function ObjectVariable:new_instance(qualifier)
   return self.__index:new(qualifier, self:get_male_variable())
end

function ObjectVariable:get_qualifier()
   return self.qualifier
end

function ObjectVariable:get_male_variable()
   return self.male_variable
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
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:get_lhs_chop_constant(constant)
   end
end

return ObjectVariable
