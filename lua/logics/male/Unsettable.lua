local Type =  require "base.type.aux.Type"
local Unsettable =  Type:__new()

package.loaded["logics.male.Unsettable"] =  Unsettable
local String =  require "base.type.String"

function Unsettable:new()
   return self:__new()
end

function Unsettable:get_variable_cast()
   return self
end

function Unsettable:get_unsettable_cast()
   return self
end

function Unsettable:set_settable_switch(mode)
end

function Unsettable:get_val()
   return self
end

function Unsettable:push_val(var)
   return false
end

function Unsettable:equate(other)
   return self == other
end

function Unsettable:val_eq(other)
   return self == other
end

function Unsettable:devar(var_assgnm)
end

function Unsettable:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::Unsettable ["))
   indentation:insert(String:string_factory(tostring(self)))
   indentation:insert(String:string_factory("]"))
   indentation:insert(String:string_factory(")"))
end

function Unsettable:__diagnose_multiple_line(indentation)
   local is_last_elem_multiple_line =  true

   indentation:insert(String:string_factory("(logics::male::Unsettable ["))
   indentation:insert(String:string_factory(tostring(self)))
   indentation:insert(String:string_factory("]"))
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Unsettable
