local Type =  require "base.type.aux.Type"

local Compound =  Type:__new()

package.loaded["logics.qualifier.Compound"] =  Compound
local String =  require "base.type.String"

function Compound:new(terminal, qualifier)
   local retval =  self:__new()
   retval.terminal =  terminal
   retval.qualifier =  qualifier
   return retval
end

function Compound:get_terminal()
   return self.terminal
end

function Compound:get_qualifier()
   return self.qualifier
end

function Compound:get_object_variable()
end

function Compound:get_meta_variable()
end

function Compound:get_variable_cast()
end

function Compound:get_compound_cast()
   return self
end

function Compound:destruct_terminal(q, terminal)
   if self:get_terminal() == terminal
   then
      return self:get_qualifier()
   end
end

function Compound:equate(other)
   local retval =  false
   local next_qual =  other:destruct_terminal(self, self:get_terminal())
   if next_qual
   then
      retval =  self:get_qualifier():equate(next_qual)
   end
   return retval
end

function Compound:devar(var_assgnm)
   local new_qual =  self:get_qualifier():devar(var_assgnm)
   return self.__index:new(self:get_terminal(), new_qual)
end

function Compound:get_val()
   return self
end

function Compound:get_name()
   local retval =  self:get_terminal():__clone():get_name()
   local this_qualifier =  self:get_qualifier()
   local next_string =  this_qualifier:get_name()
   if next_string
   then
      retval:append_string(String:string_factory("."))
      retval:append_string(next_string)
   end
   return retval
end

function Compound:__eq(other)
   local retval =  false
   local other_compound =  other:get_compound_cast()
   if other_compound
   then
      retval =
            self:get_terminal() == other_compound:get_terminal()
        and self:get_qualifier() == other_compound:get_qualifier()
   end
   return retval
end

function Compound:assign_object_variable_to_meta_variable(variable)
   return true
end

function Compound:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::qualifier::Compound "))
   indentation:insert(self:get_name())
   indentation:insert(String:string_factory(")"))
end

function Compound:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::qualifier::Compound "))
   indentation:insert(self:get_name())
   indentation:insert(String:string_factory(")"))
end

return Compound
