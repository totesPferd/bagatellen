local QualifiedBaseConcept =  require "logics.place.qualified.BaseConcept"

local BaseConcept =  QualifiedBaseConcept:__new()

package.loaded["logics.ql.term.BaseConcept"] =  BaseConcept
local String =  require "base.type.String"

function BaseConcept:new(sort, name)
   local retval =  QualifiedBaseConcept.new(self)
   retval.sort =  sort
   retval.name =  name
   return retval
end

function BaseConcept:get_name()
   return self.name
end

function BaseConcept:get_non_nil_name()
   return self.name or String:string_factory("?")
end

function BaseConcept:get_sort()
   return self.sort
end

function BaseConcept:__eq(other)
   local this_name =  self:get_name()
   if this_name
   then
      local other_base_concept =  other:get_base_concept()
      if other_base_concept
      then
         local other_name =  other:get_name()
         return
               other_name
           and this_name == other_name
           and self:get_sort() == other:get_sort()
      else
         return false
      end
   else
      return false
   end
end

function BaseConcept:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::term::BaseConcept "))
   indentation:insert(self:get_non_nil_name())
   indentation:insert(String:string_factory(": "))
   indentation:insert(self:get_sort():get_name())
   indentation:insert(String:string_factory(")"))
end

function BaseConcept:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::term::BaseConcept"))
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   deeper_indentation:insert(self:get_non_nil_name())
   deeper_indentation:insert(String:string_factory(": "))
   deeper_indentation:insert(self:get_sort():get_name())
   deeper_indentation:save()
   indentation:insert(String:string_factory(" )"))
end

return BaseConcept
