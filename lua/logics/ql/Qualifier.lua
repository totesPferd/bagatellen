local Type =  require "base.type.aux.Type"

local Qualifier =  Type:__new()

package.loaded["logics.ql.Qualifier"] =  Qualifier
local Indentation =  require "base.Indentation"
local List =  require "base.type.List"
local String =  require "base.type.String"

function Qualifier:id_factory()
   local retval =  self:__new()
   retval.qualword =  List:empty_list_factory()
   return retval
end

function Qualifier:is_id()
   return self:get_qualword():is_empty()
end

function Qualifier:get_qualword()
   return self.qualword
end

function Qualifier:append_terminal_symbol(symbol)
   self:get_qualword():append(symbol)
end

function Qualifier:append_qualifier(other)
   self:get_qualword():append_list(other.qualword)
end

function Qualifier:get_lhs_chopped_copy(qualifier)
   local retval =  self:__clone()
   if retval.qualword:drop_initial_seq(qualifier.qualword)
   then
      return retval
   end
end

function Qualifier:get_rhs_chopped_copy(qualifier)
   local retval =  self:__clone()
   if retval.qualword:drop_final_seq(qualifier.qualword)
   then
      return retval
   end
end

function Qualifier:get_name()
   local first_time =  true
   local retval =  String:empty_string_factory()
   local delimiter =  String:string_factory(".")
   for terminal in self:get_qualword():elems()
   do if first_time
      then
         first_time =  false
      else
         retval:append_string(delimiter)
      end
      retval:append_string(terminal)
   end
   return retval
end

function Qualifier:get_longest_common_tail(other)
   local this_copy_list =  self:get_qualword():__clone()
   local other_copy_list =  other:get_qualword():__clone()
   local retval =  Qualifier:id_factory()
   local looping =  true
   while looping
   do
      if this_copy_list:is_empty()
      then
         looping =  false
      elseif other_copy_list:is_empty()
      then
         looping =  false
      else
-- map/reduce et al.
         local this_tail_symbol =  this_copy_list:get_tail()
         local other_tail_symbol =  other_copy_list:get_tail()
         if this_tail_symbol == other_tail_symbol
         then
            this_copy_list:cut_tail()
            other_copy_list:cut_tail()
            retval:get_qualword():prepend(this_tail_symbol)
         else
            looping =  false
         end
      end
   end
   return retval
end

function Qualifier:__clone()
   local retval =  Qualifier:__new()
   retval.qualword =  self:get_qualword():__clone()
   return retval
end

function Qualifier:__eq(other)
   return self:get_qualword() == other:get_qualword()
end

function Qualifier:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::place::qualified::Qualifier "))
   indentation:insert(self:get_name())
   indentation:insert(String:string_factory(")"))
end

function Qualifier:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::place::qualified::Qualifier"))
   indentation:insert_newline()
   local is_last_elem_multiple_line =  true
   do
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      is_last_elem_multiple_line =  deeper_indentation:insert(self:get_name())
      deeper_indentation:save()
   end
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Qualifier
