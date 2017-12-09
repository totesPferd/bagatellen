local Type =  require "base.type.aux.Type"
local ContectedTerm =  Type:__new()

package.loaded["logics.male.ContectedTerm"] =  ContectedTerm

function ContectedTerm:new(var_ctxt, term)
   local retval =  self:__new()
   retval.var_ctxt =  var_ctxt
   retval.term =  term
   return retval
end

function ContectedTerm:new_instance(var_ctxt, term)
   return self.__index:new(var_ctxt, term)
end

function ContectedTerm:get_var_ctxt()
   return self.var_ctxt
end

function ContectedTerm:get_term()
   return self.term
end

function ContectedTerm:equate(other)
   local other_var_ctxt =  other:get_var_ctxt()
   local this_term =  self:get_term()
   local other_term =  other:get_term()
   return this_term:equate(other_var_ctxt, other_term)
end

function ContectedTerm:devar(var_assgnm)
   local new_var_ctxt =  self:get_var_ctxt():devar(var_assgnm)
   local new_term =  self:get_term():devar(var_assgnm)
   return self:new_instance(new_term, new_var_ctxt)
end

function ContectedTerm:val_eq(other)
   return self:get_term():val_eq(other:get_term())
end

function ContectedTerm:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::male::ContectedTerm "))
   self:get_var_ctxt():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(" "))
   self:get_term():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function ContectedTerm:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::male::ContectedTerm"))
   local is_last_elem_multiple_line =  true
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}

   deeper_indentation:insert_newline()
   is_last_elem_multiple_line =
      self:get_var_ctxt():__diagnose_complex(deeper_indentation)

   deeper_indentation:insert_newline()
   is_last_elem_multiple_line =
      self:get_term():__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return ContectedTerm
