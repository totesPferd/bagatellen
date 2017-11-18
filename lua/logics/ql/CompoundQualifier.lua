local Type =  require "base.type.aux.Type"

local CompoundQualifier =  Type:__new()

package.loaded["logics.ql.CompoundQualifier"] =  CompoundQualifier

function CompoundQualifier:new(terminal, qualifier)
   local retval =  self:__new()
   retval.terminal =  terminal
   retval.qualifier =  qualifier
   return retval
end

function CompoundQualifier:get_terminal()
   return self.terminal
end

function CompoundQualifier:get_qualifier()
   return self.qualifier
end

function CompoundQualifier:get_qualifier_variable()
end

function CompoundQualifier:get_compound_qualifier()
   return self
end

function CompoundQualifier:is_id()
   return false
end

function CompoundQualifier:get_name()
   local retval =  self:get_terminal():__clone()
   local this_qualifier =  self:get_qualifier()
   if not this_qualifier.is_id()
   then
      retval:append(String:string_factory("."))
      retval:append_string(this_qualifier:get_name())
   end
   return retval
end

function CompoundQualifier:destruct_terminal(terminal)
   if self:get_terminal() == terminal
   then
      return self:get_qualifier()
   end
end

function CompoundQualifier:equate(other)
   local retval =  false
   local next_qual =  other:destruct_terminal(self:get_terminal())
   if next_qual
   then
      retval =  self:get_qualifier():equate(next_qual)
   end
   return retval
end

function CompoundQualifier:devar(var_assgnm)
   local new_qual =  self:get_qualifier():devar(var_assgnm)
   return self.__index:new(self:get_terminal(), new_qual)
end

return CompoundQualifier
