local Type =  require "base.type.aux.Type"

local CompoundExpression =  Type:__new()

package.loaded["logics.ql.CompoundExpression"] =  CompoundExpression

function CompoundExpression:new(base, qualifier)
   local retval =  CompoundExpression:__new()
   retval.base =  base
   retval.qualifier =  qualifier
   return retval
end

function CompoundExpression:get_base_qualifier(ctxt)
   return self.base, self.qualifier
end

function CompoundExpression:get_variable()
end

function CompoundExpression:get_compound_expression()
   return self
end

-- do destroy this object after this method returns false!!!
function CompoundExpression:equate(dimension, other)
   local retval =  false
   local new_qual
      =  other:get_qualifier():get_rhs_chopped_copy(self:get_qualifier())
   if new_qual
   then
      local this_base, this_qualifier =  self:get_base_qualifier()
      local other_base, other_qualifier =  other:get_base_qualifier()
      retval =  this_base:equate(dimension, self:new(other_base, new_qual))
   end
   return retval
end

function CompoundExpression:devar(dimension, var_assgnm)
   local this_base, this_qualifier =  self:get_base_qualifier()
   local new_base =  this_base:devar(dimension, var_assgnm)
   return self:new(new_base, this_qualifier)
end

function CompoundExpression:__eq(other)
   local this_base, this_qualifier =  self:get_base_qualifier()
   local other_base, other_qualifier =  other:get_base_qualifier()
   return
         this_base == other_base
     and this_qualifier == other_qualifier
end

return CompoundExpression
