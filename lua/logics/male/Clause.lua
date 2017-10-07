local Type =  require "base.type.aux.Type"

local Clause =  Type:__new()


package.loaded["logics.male.Clause"] =  Clause
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Clause:new(premises, conclusion)
   local retval =  self:__new()
   retval.premises =  premises
   retval.conclusion =  conclusion
   return retval
end

function Clause:get_premises()
   return self.premises
end

function Clause:get_conclusion()
   return self.conclusion
end

function Clause:apply_substitution(substitution)
  self.get_conclusion():apply_substitution(substitution)
  for premise in self.get_premises():elems()
  do premise:apply_substitution(substitution)
  end
end

function Clause:__clone()
   local premises =  self.get_premises():__clone()
   local conclusion =  self.get_conclusion():__clone()
   local retval =  Clause:new(premises, conclusion)
   return retval
end

function Clause:__eq(other)
   return
         self.get_premises():__eq(other.get_premises())
     and self.get_conclusion():__eq(other.get_conclusion())
end

function Clause:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::Clause "))
   self:get_premises():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(" "))
   self:get_conclusion():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Clause:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::male::Clause"))
   local is_last_elem_multiple_line =  true

   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self:get_premises():__diagnose_complex(deeper_indentation)

   deeper_indentation:insert_newline()
   is_last_elem_multiple_line =
      self:get_conclusion():__diagnose_complex(deeper_indentation)

   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Clause
