local SimpleVariable =  require "logics.pel.term.Variable"

local Variable =  SimpleVariable:__new()

package.loaded["logics.ql.term.Variable"] =  Variable
local Qualifier =  require "logics.ql.Qualifier"
local String =  require "base.type.String"

function Variable:new(sort)
   return SimpleVariable.new(self, sort)
end

function Variable:get_base_spec()
   return self
end

function Variable:get_qualifier()
   return Qualifier:id_factory(self:get_sort())
end
   
function Variable:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::term::Variable "))
   indentation:insert(self.variable:get_non_nil_name())
   indentation:insert(String:string_factory(": "))
   indentation:insert(self.variable:get_sort():get_name())
   indentation:insert(String:string_factory(")"))
end

function Variable:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::term::Variable"))
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   deeper_indentation:insert(self.variable:get_non_nil_name())
   deeper_indentation:insert(String:string_factory(": "))
   deeper_indentation:insert(self.variable:get_sort():get_name())
   deeper_indentation:save()
   indentation:insert(String:string_factory(" )"))
end

return Variable
