local Type =  require "base.type.aux.Type"

local Compound =  Type:__new()

package.loaded["logics.pel.Compound"] =  Compound
local List =  require "base.type.List"

function Compound:new(symbol, sub_term_list)
   local retval =  self:__new()
   retval.symbol =  symbol
   retval.sub_term_list =  sub_term_list
   return retval
end

function Compound:new_instance(symbol, sub_term_list)
   return self.__index:new(symbol, sub_term_list)
end

function Compound:get_symbol()
   return self.symbol
end

function Compound:get_sub_term_list()
   return self.sub_term_list
end

function Compound:get_variable()
end

function Compound:get_meta_variable_cast()
end

function Compound:get_object_variable_cast()
end

function Compound:get_compound_cast()
   return self
end

function Compound:finish(term)
   return true
end

function Compound:get_val()
   return self
end

function Compound:destruct_compound(symbol, arity)
   if symbol == self:get_symbol()
   then
      return self:get_sub_term_list():__clone()
   end
end

function Compound:backup()
end

function Compound:restore()
end

-- do destroy this object after this method returns false!!!
function Compound:equate(other)
   local equatable =  false
   local other_sub_term_list =  other:destruct_compound(
         self:get_symbol()
      ,  #self:get_sub_term_list() )
   if other_sub_term_list
   then
      equatable =  true
      for sub_term in self:get_sub_term_list():elems()
      do local other_sub_term =  other_sub_term_list:get_head()
         other_sub_term_list:cut_head()
         equatable =  sub_term:equate(other_sub_term)
         if not equatable
         then break
         end
      end
   end

   return equatable
end

function Compound:devar(var_assgnm)
-- matter for using map, zip, reduce et al.
   local new_sub_term_list =  List:empty_list_factory()
   for sub_term in self:get_sub_term_list():elems()
   do new_sub_term_list:append(sub_term:devar(var_assgnm))
   end

   return self:new_instance(self:get_symbol(), new_sub_term_list)
end

function Compound:__eq(other)
   local retval =  false
   local other_compound =  other:get_compound_cast()
   if other_compound
   then
      retval =  self:get_symbol() == other_compound:get_symbol()
      if retval
      then
         retval =  true
-- wieder Material fuer moses et al.
         local other_sub_terms
            =  other_compound:get_sub_term_list():__clone()
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

return Compound
