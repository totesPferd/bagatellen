local MALEObjectVariable =  require "logics.male.ObjectVariable"

local ObjectVariable =  MALEObjectVariable:__new()

package.loaded["logics.ql.ObjectVariable"] =  ObjectVariable
local String =  require "base.type.String"
local VarAssgnm =  require "logics.male.VarAssgnm"

function ObjectVariable:new()
   local retval =  MALEObjectVariable.new(self)
   return retval
end

function ObjectVariable:get_compound_cast()
end

function ObjectVariable:finish(term)
   return true
end

function ObjectVariable:destruct_terminal(terminal)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:destruct_terminal(terminal)
   end
end

function ObjectVariable:equate(other)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:equate(other)
   elseif other:finish(self)
   then
      self:set_val(other)
      return true
   else
      return false
   end
end

function ObjectVariable:get_name()
   return self.name
end

function ObjectVariable:set_name(name)
   self.name =  name
end

function ObjectVariable:get_non_nil_name()
   return self:get_name() or String:string_factory("?")
end

function ObjectVariable:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::ObjectVariable "))
   indentation:insert(self:get_non_nil_name())
   local this_val =  self:get_val()
   if this_val
   then
      indentation:insert(String:string_factory(" "))
      self:get_val():__diagnose_single_line(indentation)
   end
   indentation:insert(String:string_factory(")"))
end

function ObjectVariable:__diagnose_multiple_line(indentation)
   local is_last_elem_multiple_line =  true

   indentation:insert(String:string_factory("(logics::ql::ObjectVariable"))
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   deeper_indentation:insert(self:get_non_nil_name())
   local this_val =  self:get_val()
   if this_val
   then
      deeper_indentation:insert_newline()
      is_last_elem_multiple_line
         =  this_val:__diagnose_complex(deeper_indentation)
   end
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return ObjectVariable
