local GeneralVariableContext =  require "logics.place.general.VariableContext"

local VariableContext =  GeneralVariableContext:__new()

package.loaded["logics.pel.VariableContext"] =  VariableContext
local List =  require "base.type.List"
local String =  require "base.type.String"
local StringSet =  require "base.type.set.StringSet"

function VariableContext:new()
   local retval =  GeneralVariableContext.new(self)
   retval.variables =  List:empty_list_factory()
   return retval
end

function VariableContext:uniquize()
   local do_not_use_set =  StringSet:empty_set_factory()
   for variable in self.variables:elems()
   do local name =  variable:get_name() or String:string_factory("x")
      while do_not_use_set:is_in(name)
      do name:append_string(String:string_factory("'"))
      end
      variable:set_name(name)
      do_not_use_set:add(name)
   end
end

function VariableContext:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::pel::VariableContext"))
   for variable in self.variables:elems()
   do local pel_variable =  variable:is_system("pel")
      if pel_variable
      then
         indentation:insert(String:string_factory(" "))
         indentation:insert(pel_variable:get_non_nil_name())
         indentation:insert(String:string_factory(": "))
         indentation:insert(pel_variable:get_sort():get_name())
      else
         indentation:insert(String:string_factory("<unnamed>"))
      end
   end
   indentation:insert(String:string_factory(")"))
end

function VariableContext:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::pel::VariableContext"))
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   for variable in self.variables:elems()
   do local pel_variable =  variable:is_system("pel")
      if pel_variable
      then
         deeper_indentation:insert_newline()
         deeper_indentation:insert(pel_variable:get_non_nil_name())
         deeper_indentation:insert(String:string_factory(": "))
         deeper_indentation:insert(pel_variable:get_sort():get_name())
      else
         deeper_indentation:insert(String:string_factory("<unnamed>"))
      end
   end
   deeper_indentation:save()
   indentation:insert(String:string_factory(" )"))
end

return VariableContext
