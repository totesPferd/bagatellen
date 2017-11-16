local QLConstant =  require "logics.ql.Constant"

local Constant =  QLConstant:__new()

package.loaded["logics.dql.Constant"] =  Constant
local String =  require "base.type.String"

function Constant:new(symbol)
   return QLConstant.new(self, symbol)
end

function Constant:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::dql::Constant "))
   do indentation:insert(String:string_factory(" "))
      self:get_symbol():__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function Constant:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::dql::Constant "))
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

return Constant
