local Type =  require "base.type.aux.Type"

local Constant =  Type:__new()

package.loaded["logics.ql.Constant"] =  Constant

function Constant:new(qualifier, symbol)
   local retval =  self:__new()
   retval.qualifier =  qualifier
   retval.symbol =  symbol
   return retval
end

function Constant:new_constant(qualifier)
   return self.__index:new(qualifier, self:get_symbol())
end

function Constant:new_instance(qualifier)
   return self.__index:new(qualifier, self:get_symbol())
end

function Constant:get_qualifier()
   return self.qualifier
end

function Constant:get_symbol()
   return self.symbol
end

function Constant:get_variable_cast()
end

function Constant:get_constant_cast()
   return self
end

function Constant:equate(other)
   local retval =  false
   local other_dev_qual =  self:get_lhs_chop_constant(other)
   if other_dev_qual
   then
      local this_qual =  self:get_qualifier()
      this_qual:append_qualifier(other_dev_qual)
      retval =  true
   end
   return retval
end

function Constant:get_lhs_chop_constant(other)
   local other_constant =  other:get_constant_cast()
   if other_constant
   then
      if self:get_symbol() == other_constant:get_symbol()
      then
         local this_qual =  self:get_qualifier()
         local other_qual =  other_constant:get_qualifier()
         local dev_qual =  this_qual:get_lhs_chopped(other_qual)
         return dev_qual
      end
   end
end

function Constant:devar(var_assgnm)
   local new_qual =  self:get_qualifier():devar(var_assgnm)
   return self:new_constant(new_qual)
end

function Constant:assign_object_variable_to_meta_variable(variable)
   return true
end

return Constant
