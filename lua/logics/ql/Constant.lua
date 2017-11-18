local Type =  require "base.type.aux.Type"

local Constant =  Type:__new()

package.loaded["logics.ql.Constant"] =  Constant

function Constant:new(symbol, qualifier)
   local retval =  self:__new()
   retval.symbol =  symbol
   retval.qualifier =  qualifier
   return retval
end

function Constant:new_ql_instance_added_qualifier(qualifier)
   local new_qual =  self:get_qualifier():__clone()
   new_qual:append_qualifier(qualifier)
   return self:new_ql_instance(new_qual)
end

function Constant:new_ql_instance(qualifier)
   return self.__index:new(self:get_symbol(), qualifier)
end

function Constant:get_symbol()
   return self.symbol
end

function Constant:get_qualifier()
   return self.qualifier
end

function Constant:get_variable()
end

function Constant:get_object_variable()
end

function Constant:get_constant()
   return self
end

function Constant:append_qualifier(qualifier)
   self.qualifier:append_qualifier(qualifier)
end

function Constant:be_an_object_variable(variable)
end

function Constant:destruct_constant(constant)
   if self == constant
   then
      return self
   end
end

function Constant:equate(other)
   local other_constant =  other:destruct_constant(self)
   if other_constant
   then
      return true
   else
      return false
   end
end

function Constant:devar(var_assgnm)
   return self
end

function Constant:__eq(other)
   local retval =  false
   local other_constant =  other:get_constant()
   if other_constant
   then
      retval =
            self:get_symbol() == other:get_symbol()
        and self:get_qualifier() == other:get_qualifier()
   end
   return retval
end


-- --- refactoring.

function Constant:get_rhs_chopped_copy(qualifier)
   local new_lhs, new_rhs
      =  self:get_qualifier():get_rhs_chopped_copy(qualifier)
   if new_lhs
   then
      return
            self:__index:new(
                  self:get_symbol()
               ,  new_lhs )
         ,  new_rhs
   end
end


return Constant
