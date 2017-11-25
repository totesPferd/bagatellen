local Type =  require "base.type.aux.Type"

local QualSymbol =  Type:__new()

package.loaded["logics.pel.QualSymbol"] =  QualSymbol

function QualSymbol:new(qualifier)
   local retval self:__new()
   retval.qualifier =  qualifier
   return retval
end

function QualSymbol:get_def_symbol_cast()
end

function QualSymbol:get_eq_symbol_cast()
end

function QualSymbol:get_qual_symbol_cast()
   return self
end

function QualSymbol:get_qualifier()
   return self.qualifier
end

function QualSymbol:__eq(other)
   local retval =  false
   local other_qual_symbol =  other:get_qual_symbol()
   if other_qual_symbol
   then
      retval =  self:get_qualifier() == other_qual_symbol:get_qualifier()
   end
   return retval
end

function QualSymbol:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::pel::QualSymbol "))
   self:get_qualifier():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function QualSymbol:__diagnose_multiple_line(indentation)
   local is_last_elem_multiple_line =  true

   indentation:insert(String:string_factory("(logics::pel::QualSymbol"))
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line
      =  self:get_qualifier():__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return QualSymbol

