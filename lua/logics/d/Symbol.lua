local Type =  require "base.type.aux.Type"

local Symbol =  Type:__new()

package.loaded["logics.d.Symbol"] =  Symbol

function Symbol:new(name)
   local retval =  set:__new()
   retval.name =  name
   return retval
end

function Symbol:get_name()
   return self.name
end

function Symbol:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::d::Symbol "))
   indentation:insert(self:get_name())
   indentation:insert(String:string_factory(")"))
end

function Symbol:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::d::Symbol"))
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   deeper_indentation:insert(self:get_name())
   deeper_indentation:save()
   indentation:insert(String:string_factory(")"))
end

return Symbol
