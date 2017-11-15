local QLConcept =  require "logics.ql.Concept"

local Concept =  QLConcept:__new()

package.loaded["logics.dql.Concept"] =  Concept
local String =  require "base.type.String"

function Concept:new(symbol)
   return QLConcept.new(self, symbol)
end

function Concept:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::dql::Concept "))
   do indentation:insert(String:string_factory(" "))
      self:get_symbol():__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function Concept:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::dql::Concept "))
   local is_last_elem_multiple_line =  true
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   do deeper_indentation:insert_newline()
      is_last_elem_multiple_line =
         self:get_symbol():__diagnose_complex(deeper_indentation)
   end
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Concept
