local Term =  require "logics.pel.Term"

local Compound =  Term:__new()

package.loaded["logics.pel.term.Compound"] =  Compound
local List =  require "base.type.List"

function Compound:new(variable_spec, fun, term_list)
   local retval =  Compound:__new()
   retval.variable_spec =  variable_spec
   retval.fun =  fun
   retval.term_list =  term_list
   return retval
end

function Compound:get_fun()
   return self.fun
end

function Compound:get_sort()
   return self:get_fun():get_sort()
end

function Compound:get_compound()
   return self
end

function Compound:get_substituted(substitution)
   local variable_spec =  substitution:get_d0(substitution)
   local res_term_list =  List:empty_list_factory()
   for term in self.term_list:elems()
   do res_term_list:append(term:get_substituted(substitution))
   end
   return Compound:new(variable_spec, self:get_fun(), res_term_list)
end

function Compound:_aux_unif(substitution, term)
   local other_term =  term:get_base_term()
   if other_term
   then
      local other_compound =  other_term:get_compound()
      if other_compound
      then
         if self:get_fun() == other_compound:get_fun()
         then
            local retval =  true
            local other_term_list =  other_compound.term_list:__clone()
            for sub_term in self.term_list:elems()
            do retval =  sub_term:_aux_unif(
                  substitution
               ,  other_term_list:get_head() )
               if retval
               then
                  other_term_list:cut_head()
               else
                  return false
               end
            end
         else
            return false
         end
      else
         return false
      end
   else
      local skolem =  term:get_skolem()
      if skolem
      then
         substitution:complete()
         local new_base_term =  self:get_substituted(substitution)
         skolem:set_base_term(new_base_term)
         return true
      else
         return false
      end
   end
end

function Compound:__eq(other)
   local other_compound =  other:get_compound()
   if other_compound
   then
     return
         self:get_fun() == other:get_fun()
     and self:get_term_list() == other:get_term_list()
   else
      return false
   end
end

return Compound
