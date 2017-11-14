local Type =  require "base.type.aux.Type"

local CompoundExpression =  Type:__new()

package.loaded["logics.ql.CompoundExpression"] =  CompoundExpression

function CompoundExpression:new(base, qualifier)
   local retval =  self:__new()
   retval.base =  base
   retval.qualifier =  qualifier
   return retval
end

function CompoundExpression:get_base_qualifier()
   return self.base, self.qualifier
end

function CompoundExpression:get_meta_variable()
end

function CompoundExpression:get_variable()
end

function CompoundExpression:get_compound_expression()
   return self
end

function CompoundExpression:be_a_variable()
end

function CompoundExpression:destruct_concept(concept)
   local this_base, this_qualifier =  this:get_base_qualifier()
   return this_base:destruct_concept(concept)
end

function CompoundExpression:get_val()
   return self
end

-- do destroy this object after this method returns false!!!
function CompoundExpression:equate(other)
   local this_base, this_qualifier =  self:get_base_qualifier()
   local other_base, other_qualifier =  other:get_base_qualifier()
   local retval =  false
   local new_qual
      =  other_qualifier:get_rhs_chopped_copy(this_qualifier)
   if new_qual
   then
      retval =  this_base:equate(self:new(other_base, new_qual))
   end
   return retval
end

function CompoundExpression:devar(var_assgnm)
   local this_base, this_qualifier =  self:get_base_qualifier()
   local new_base =  this_base:devar(var_assgnm)
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
