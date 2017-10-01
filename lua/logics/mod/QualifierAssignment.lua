local Type =  require "base.type.aux.Type"

local QualifierAssignment =  Type:__new()

package.loaded["logics.mod.QualifierAssignment"] =  QualifierAssignment
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function QualifierAssignment:new(qualifier, module_instance)
   local retval =  QualifierAssignment:__new()
   retval.qualifier =  qualifier
   retval.module_instance =  module_instance
   return retval
end

function QualifierAssignment:get_qualifier()
   return self.qualifier
end

function QualifierAssignment:get_module_instance()
   return self.module_instance
end

function QualifierAssignment:get_chopped_copy(qualifier)
   local ret_qual =  self:get_qualifier():get_chopped_copy(qualifier)
   if ret_qual
   then
      return QualifierAssignment:new(ret_qual, self:get_module_instance())
   end
end

function QualifierAssignment:__clone()
   return self:new(self:get_qualifier():__clone(), self:get_module_instance():__clone())
end

function QualifierAssignment:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::mod::QualifierAssignment "))
   self:get_qualifier():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(": "))
   self:get_module_instance():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function QualifierAssignment:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::mod::QualifierAssignment"))
   indentation:insert_newline()
   local is_last_elem_multiple_line =  true
   do
      local deeper_indentation =
         indentation:get_deeper_indentation_factory {}
      is_last_elem_multiple_line =  self:get_qualifier():__diagnose_complex(deeper_indentation)
      deeper_indentation:insert(String:string_factory(": "))
      self:get_module_instance():__diagnose_complex(deeper_indentation)
      deeper_indentation:save()
   end
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return QualifierAssignment
