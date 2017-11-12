local QLCompoundExpression =  require "logics.ql.CompoundExpression"

local CompoundExpression =  QLCompoundExpression:__new()

package.loaded["logics.dql.CompoundExpression"] =  CompoundExpression
local String =  require "base.type.String"

function CompoundExpression:new(base, qualifier)
   return QLCompoundExpression.new(self, base, qualifier)
end

function CompoundExpression:__diagnose_single_line(indentation)
   local this_base, this_qualifier =  self:get_base_qualifier()
   local f_name =  this_qualifier:get_name()
   indentation:insert(String:string_factory("(logics::dql::CompoundExpression "))
   indentation:insert(f_name)
   do indentation:insert(String:string_factory(" "))
      this_base:__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function CompoundExpression:__diagnose_multiple_line(indentation)
   local this_base, this_qualifier =  self:get_base_qualifier()
   local f_name =  this_qualifier:get_name()
   indentation:insert(String:string_factory("(logics::dql::CompoundExpression "))
   indentation:insert(f_name)
   local is_last_elem_multiple_line =  true
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   do deeper_indentation:insert_newline()
      is_last_elem_multiple_line =
         this_base:__diagnose_complex(deeper_indentation)
   end
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return CompoundExpression
