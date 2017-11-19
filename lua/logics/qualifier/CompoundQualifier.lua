local Type =  require "base.type.aux.Type"

local CompoundQualifier =  Type:__new()

package.loaded["logics.qualifier.CompoundQualifier"] =  CompoundQualifier
local String =  require "base.type.String"

function CompoundQualifier:new(ctxt_pt, terminal, qualifier)
   local retval =  self:__new()
   retval.terminal =  terminal
   retval.qualifier =  qualifier
   retval.ctxt_pt =  ctxt_pt
   return retval
end

function CompoundQualifier:get_terminal()
   return self.terminal
end

function CompoundQualifier:get_qualifier()
   return self.qualifier
end

function CompoundQualifier:get_object_variable()
end

function CompoundQualifier:get_meta_variable()
end

function CompoundQualifier:get_variable_cast()
end

function CompoundQualifier:get_compound_qualifier_cast()
   return self
end

function CompoundQualifier:destruct_terminal(q, terminal)
   if self:get_terminal() == terminal
   then
      return self:get_qualifier()
   end
end

function CompoundQualifier:equate(other)
   local retval =  false
   local next_qual =  other:destruct_terminal(self, self:get_terminal())
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

function CompoundQualifier:get_val()
   return self
end

function CompoundQualifier:get_name()
   local retval =  self:get_terminal():__clone()
   local this_qualifier =  self:get_qualifier()
   if not this_qualifier:is_id()
   then
      retval:append_string(String:string_factory("."))
      retval:append_string(this_qualifier:get_name())
   end
   return retval
end

function CompoundQualifier:__eq(other)
   local retval =  false
   local other_compound_qualifier =  other:get_compound_qualifier_cast()
   if other_compound_qualifier
   then
      retval =
            self:get_terminal() == other_compound_qualifier:get_terminal()
        and self:get_qualifier() == other_compound_qualifier:get_qualifier()
   end
   return retval
end

function CompoundQualifier:get_lhs_chopped(qualifier)
   local next_qualifier =  qualifier:destruct_terminal(self, self:get_terminal())
   if next_qualifier
   then
      return self:get_qualifier():get_lhs_chopped(next_qualifier)
   end
end

return CompoundQualifier
