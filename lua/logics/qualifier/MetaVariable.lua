local MALEMetaVariable =  require "logics.male.MetaVariable"

local MetaVariable =  MALEMetaVariable:__new()

package.loaded["logics.qualifier.MetaVariable"] =  MetaVariable
local CompoundQualifier =  require "logics.qualifier.CompoundQualifier"

function MetaVariable:new()
   return MALEMetaVariable.new(self)
end

function MetaVariable:new_compound_qualifier(terminal, qualifier)
   return CompoundQualifier:new(terminal, qualifier)
end

function MetaVariable:get_compound_qualifier()
end

function MetaVariable:destruct_terminal(terminal)
   local this_val =  self:get_val()
   if this_val
   then
      if this_val:get_terminal() == terminal
      then
         return this_val:get_qualifier()
      end
   else
      local new_var =  self:copy()
      local new_val =  self:new_compound_qualifier(terminal, new_var)
      self:set_val(new_val)
      return new_var
   end
end

return MetaVariable
