local Type =  require "base.type.aux.Type"

local Compound =  Type:__new()

package.loaded["logics.rhs_object.Compound"] =  Compound
local String =  require "base.type.String"

function Compound:new(terminal, rhs_object)
   local retval =  self:__new()
   retval.terminal =  terminal
   retval.rhs_object =  rhs_object
   return retval
end

function Compound:get_terminal()
   return self.terminal
end

function Compound:get_rhs_object()
   return self.rhs_object
end

function Compound:get_variable_cast()
end

function Compound:get_compound_cast()
   return self
end

function Compound:set_settable_switch(mode)
   self:get_rhs_object():set_settable_switch(mode)
end

function Compound:destruct_terminal(terminal)
   if self:get_terminal() == terminal
   then
      return self:get_rhs_object()
   end
end

function Compound:get_val()
   return self
end

function Compound:get_val_rec()
   return self
end

function Compound:push_val(var)
   return var:set_val(self)
end

function Compound:equate(other)
   local retval =  false
   local next_qual =  other:destruct_terminal(self:get_terminal())
   if next_qual
   then
      retval =  self:get_rhs_object():equate(next_qual)
   end
   return retval
end

function Compound:devar(var_assgnm)
   local new_qual =  self:get_rhs_object():devar(var_assgnm)
   return self.__index:new(self:get_terminal(), new_qual)
end

function Compound:get_name()
   return self:get_terminal():get_name() or String:string_factory("??")
end

function Compound:val_eq(other)
   local retval =  false
   local other_compound =  other:get_val():get_compound_cast()
   if other_compound
   then
      retval =
            self:get_terminal() == other_compound:get_terminal()
        and
                  self:get_rhs_object():get_val():val_eq(
                        other_compound:get_rhs_object():get_val() )
   end
   return retval
end

function Compound:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::ql::Compound "))
   indentation:insert(self:get_name())
   indentation:insert(String:string_factory(" "))
   self:get_rhs_object():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function Compound:__diagnose_multiple_line(indentation)
   local is_last_elem_multiple_line =  true

   indentation:insert(String:string_factory("(logics::ql::Compound "))
   indentation:insert(self:get_name())
   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line
      =  self:get_rhs_object():__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return Compound
