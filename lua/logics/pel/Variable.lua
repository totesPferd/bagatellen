local MALEVariable =  require "logics.male.Variable"

local Variable =  MALEVariable:__new()

package.loaded["logics.pel.Variable"] =  Variable
local String =  require "base.type.String"

function Variable:new(settable)
   return MALEVariable.new(self, settable)
end

function Variable:get_compound_cast()
end

function Variable:destruct_compound(symbol, arity)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:destruct_compound(symbol, arity)
   end
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
   indentation:insert(String:string_factory("(logics::pel::Variable ["))
   indentation:insert(String:string_factory(tostring(self:get_value_store())))
   indentation:insert(String:string_factory(" "))
   indentation:insert(String:string_factory(tostring(self)))
   indentation:insert(String:string_factory("] "))
   indentation:insert(self:get_non_nil_name())
   local this_val =  self:get_val()
   if this_val
   then
      indentation:insert(String:string_factory(" "))
      self:get_val():__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function Variable:__diagnose_multiple_line(indentation)
   local is_last_elem_multiple_line =  true

   indentation:insert(String:string_factory("(logics::pel::Variable ["))
   indentation:insert(String:string_factory(tostring(self:get_value_store())))
   indentation:insert(String:string_factory(" "))
   indentation:insert(String:string_factory(tostring(self)))
   indentation:insert(String:string_factory("] "))
   indentation:insert(self:get_non_nil_name())
   local this_val =  self:get_val()
   if this_val
   then
      indentation:insert_newline()
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      is_last_elem_multiple_line
         =  this_val:__diagnose_complex(deeper_indentation)
      deeper_indentation:save()
   end
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Variable
