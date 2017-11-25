local Type =  require "base.type.aux.Type"

local EqSymbol =  Type:__new()

package.loaded["logics.pel.EqSymbol"] =  EqSymbol

function EqSymbol:new()
   return self:__new()
end

function EqSymbol:get_def_symbol_cast()
end

function EqSymbol:get_eq_symbol_cast()
   return self
end

function EqSymbol:get_qual_symbol_cast()
end

function EqSymbol:__eq(other)
   local retval =  false
   local other_eq_symbol =  other:get_eq_symbol()
   if other_eq_symbol
   then
      retval =  true
   end
   return retval
end

return EqSymbol

