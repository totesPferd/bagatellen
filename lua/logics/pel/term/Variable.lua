local SimpleVariable =  require "logics.place.general.Variable"

local Variable =  SimpleVariable:__new()

package.loaded["logics.pel.term.Variable"] =  Variable
local String =  require "base.type.String"

function Variable:new(sort)
   local retval =  SimpleVariable.new(self)
   retval.sort =  sort
   return retval
end

function Variable:is_system(system)
   if system == "pel"
   then
      return self
   end
end

function Variable:get_sort()
   return self.sort
end

function Variable:get_compound()
end
   
function Variable:get_name()
   return self.name
end

function Variable:set_name(name)
   self.name =  name
end

function Variable:get_non_nil_name()
   return self:get_name() or String:string_factory("?")
end

function Variable:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::pel::term::Variable "))
   indentation:insert(self:get_non_nil_name())
   indentation:insert(String:string_factory(": "))
   indentation:insert(self:get_sort():get_name())
   indentation:insert(String:string_factory(")"))
end

function Variable:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::pel::term::Variable"))
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   deeper_indentation:insert(self:get_non_nil_name())
   deeper_indentation:insert(String:string_factory(": "))
   deeper_indentation:insert(self:get_sort():get_name())
   deeper_indentation:save()
   indentation:insert(String:string_factory(" )"))
end

return Variable
