local Type =  require "base.type.aux.Type"

local Compound =  Type:__new()

package.loaded["logics.pel.Compound"] =  Compound
local List =  require "base.type.List"
local String =  require "base.type.String"

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

function Compound:get_variable_cast()
end

function Compound:get_compound_cast()
   return self
end

function Compound:set_unsettable()
   for sub_term in self:get_sub_term_list():elems()
   do sub_term:set_unsettable()
   end
end

function Compound:get_val()
   return self
end

function Compound:destruct_compound(symbol, arity)
   if symbol == self:get_symbol()
   then
      return self:get_sub_term_list()
   end
end

function Compound:get_bound_val()
   return self
end

function Compound:push_val(var)
   return var:set_val(self)
end

-- do destroy this object after this method returns false!!!
function Compound:equate(other)
   local equatable =  false
   local other_sub_term_list =  other:destruct_compound(
         self:get_symbol()
      ,  self:get_sub_term_list():__len() )
   if other_sub_term_list
   then
      local other_sub_term_list_copy =  other_sub_term_list:__clone()
      equatable =  true
      for sub_term in self:get_sub_term_list():elems()
      do local other_sub_term =  other_sub_term_list_copy:get_head()
         other_sub_term_list_copy:cut_head()
         equatable =  sub_term:equate(other_sub_term)
         if not equatable
         then
            break
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

function Compound:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::pel::Compound "))
   self:get_symbol():__diagnose_single_line(indentation)
   for sub_term in self:get_sub_term_list():elems()
   do indentation:insert(String:string_factory(" "))
      sub_term:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function Compound:__diagnose_multiple_line(indentation)
   local is_last_elem_multiple_line =  true

   indentation:insert(String:string_factory("(logics::pel::Compound"))
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line
      =  self:get_symbol():__diagnose_complex(deeper_indentation)
   for sub_term in self:get_sub_term_list():elems()
   do deeper_indentation:insert_newline()
      is_last_elem_multiple_line
         =  sub_term:__diagnose_complex(deeper_indentation)
   end
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Compound
