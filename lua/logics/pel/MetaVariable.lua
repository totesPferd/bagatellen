local MALEMetaVariable =  require "logics.male.MetaVariable"

local MetaVariable =  MALEMetaVariable:__new()

package.loaded["logics.pel.MetaVariable"] =  MetaVariable
local List =  require "base.type.List"

function MetaVariable:new()
   return MALEMetaVariable.new(self)
end

function MetaVariable:destruct_compound_expression(symbol, arity)
   local this_val =  self:get_val()
   if this_val
   then
      return this_val:destruct_compound_expression(symbol, arity)
   else
-- map/reduce et al.!!!
      local retval =  List:empty_list_factory()
      for i = 1,arity
      do retval:append(self:new_instance())
      end
      self:set_val(retval)
      return retval:__clone()
   end
end

return MetaVariable
