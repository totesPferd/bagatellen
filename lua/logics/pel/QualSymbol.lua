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

return QualSymbol

