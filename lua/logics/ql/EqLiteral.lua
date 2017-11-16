local Type =  require "base.type.aux.Type"

local EqLiteral =  Type:__new()

package.loaded["logics.ql.EqLiteral"] =  EqLiteral

function EqLiteral:new(lhs_term, rhs_term)
   local retval =  self:__new()
   retval.lhs_term =  lhs_term
   retval.rhs_term =  rhs_term
   return retval
end

function EqLiteral:new_instance(lhs_term, rhs_term)
   return EqLiteral:new(lhs_term, rhs_term)
end

function EqLiteral:get_lhs_term()
   return self.lhs_term
end

function EqLiteral:get_rhs_term()
   return self.rhs_term
end

function EqLiteral:get_eq_literal()
   return self
end

function EqLiteral:get_to_literal()
end

function EqLiteral:equate(other)
   local retval =  false
   local other_eq_literal =  other:get_eq_literal()
   if other_eq_literal
   then
      retval =  self:get_lhs_term():equate(other_eq_literal:get_lhs_term())
      if retval
      then
         retval =  self:get_rhs_term():equate(other_eq_literal:get_rhs_term())
      end
   end
   return retval
end

function EqLiteral:devar(var_assgnm)
   local new_lhs_term =  self:get_lhs_term():devar(var_assgnm)
   local new_rhs_term =  self:get_rhs_term():devar(var_assgnm)
   return self:new_instance(new_lhs_term, new_rhs_term)
end

return EqLiteral
