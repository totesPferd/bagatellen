local QSimpleVariable =  require "logics.place.qsimple.Variable"

local Variable =  QSimpleVariable:__new()

package.loaded["logics.qpel.term.Variable"] =  Variable
local Sort =  require "logics.qpel.Sort"
local String =  require "base.type.String"
local Qualifier =  require "logics.place.qualified.Qualifier"

function Variable:is_system(system)
   if system == "qsimple"
   then
      return self
   end
end

function Variable:get_sort()
   local sort =  self:get_base():get_sort()
   local base, qualifier
   local qsort =  sort:is_system("qsimple")
   if qsort
   then
      base =  qsort:get_base()
      qualifier =  qsort:get_qualifier():__clone()
   else
      base =  sort
      qualifier =  Qualifier:id_factory()
   end
   qualifier:append_qualifier(self:get_qualifier())
   return Sort:qualifying_factory(base, qualifier)
end

function Variable:get_compound()
end
   
function Variable:get_name()
   return self:get_base_variable():get_name()
end

function Variable:set_name(name)
   self:get_base_variable():set_name(name)
end

function Variable:get_fqn()
   local retval =  self:get_name():__clone()
   if retval
   then
      retval:append_string(String:string_factory("."))
      retval:append_string(self:get_base_qualifier():get_name())
      return retval
   end
end

function Variable:get_non_nil_name()
   return self:get_fqn() or String:string_factory("?")
end

function Variable:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::qpel::term::Variable "))
   indentation:insert(self:get_non_nil_name())
   indentation:insert(String:string_factory(": "))
   indentation:insert(self:get_sort():get_name())
   indentation:insert(String:string_factory(")"))
end

function Variable:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::qpel::term::Variable"))
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
