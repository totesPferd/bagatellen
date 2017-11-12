local Type =  require "base.type.aux.Type"

local CompoundExpression =  Type:__new()

package.loaded["logics.pel.CompoundExpression"] =  CompoundExpression
local List =  require "base.type.List"

function CompoundExpression:new(symbol, sub_term_list)
   local retval =  self:__new()
   retval.symbol =  symbol
   retval.sub_term_list =  sub_term_list
   return retval
end

function CompoundExpression:get_symbol()
   return self.symbol
end

function CompoundExpression:get_sub_term_list()
   return self.sub_term_list
end

function CompoundExpression:get_variable()
end

function CompoundExpression:get_compound_expression()
   return self
end

-- do destroy this object after this method returns false!!!
function CompoundExpression:equate(other)
   local equatable =  false
   local other_compound_expression =  other:get_compound_expression()
   if other_compound_expression
   then
      equatable =  true
   -- im folgenden zip verwenden sobald verfügbar!
      local other_sub_terms
         =  other_compound_expression:get_sub_term_list():__clone()
      for sub_term in self:get_sub_term_list():elems()
      do local other_sub_term =  other_sub_terms:get_head()
         other_sub_terms:cut_head()
         equatable =  sub_term:equate(other_sub_term)
         if not equatable
         then break
         end
      end
   end
   return equatable
end

function CompoundExpression:devar(var_assgnm)
-- matter for using map, zip, reduce et al.
   local new_sub_term_list =  List:empty_list_factory()
   for sub_term in self:get_sub_term_list():elems()
   do new_sub_term_list:append(sub_term:devar(var_assgnm))
   end

   return self:new(self:get_symbol(), new_sub_term_list)
end

function CompoundExpression:__eq(other)
   local retval =  false
   local other_compound_expression =  other:get_compound_expression()
   if other_compound_expression
   then
      retval =  self:get_symbol() == other_compound_expression:get_symbol()
      if retval
      then
         retval =  true
-- wieder Material fuer moses et al.
         local other_sub_terms
            =  other_compound_expression:get_sub_term_list():__clone()
         for sub_term in self:get_sub_term_list():elems()
         do local other_sub_term =  other_sub_terms:get_head()
            other_sub_terms:cut_head()
            retval =  sub_term == other_sub_term
            if not retval
            then
               break
            end
         end
      end
   end
   return retval
end

-- tut mir leid, geht nicht besser zu machen!
-- ...gehört eigentlich nach logics.qpel
function CompoundExpression:get_chopped_qualifier_copy(qualifier)
   local new_symbol
      =  self:get_symbol():get_chopped_qualifier_copy(qualifier)
-- map/reduce et al.!!!
   local new_sub_term_list =  List:empty_list_factory()
   for sub_term in self:get_sub_term_list():elems()
   do new_sub_term_list:append(
      sub_term:get_chopped_qualifier_copy(qualifier) )
   end
   return self:new(new_symbol, new_sub_term_list)
end

return CompoundExpression
