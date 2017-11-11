local Type =  require "base.type.aux.Type"

local CompoundExpression =  Type:__new()

package.loaded["logics.ql.CompoundExpression"] =  CompoundExpression

function CompoundExpression:new(base, qualifier)
   local retval =  CompoundExpression:__new()
   retval.base =  base
   retval.qualifier =  qualifier
   return retval
end

function CompoundExpression:get_base()
   return self.base
end

function CompoundExpression:get_qualifier()
   return self.qualifier
end

function CompoundExpression:get_variable()
end

function CompoundExpression:get_compound_expression()
   return self
end

-- do destroy this object after this method returns false!!!
function CompoundExpression:equate(other)
   local retval =  false
   local new_qual
      =  other:get_qualifier():get_rhs_chopped_copy(self:get_qualifier())
   if new_qual
   then
      retval =  self:get_base():equate(self:new(other:get_base(), new_qual))
   end
   return retval
end

function CompoundExpression:devar(var_assgnm)
   local new_base =  self:get_base():devar(var_assgnm)
   return self:new(new_base, self:get_qualifier())
end

function CompoundExpression:__eq(other)
   return
         self:get_base() == other:get_base()
     and self:get_qualifier() == other:get_qualifier()
end

return CompoundExpression
