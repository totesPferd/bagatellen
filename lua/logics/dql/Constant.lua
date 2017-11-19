local QLConstant =  require "logics.qualifier.CompoundQualifier"

local Constant =  QLConstant:__new()

package.loaded["logics.dql.Constant"] =  Constant
local String =  require "base.type.String"

function Constant:new(symbol, qualifier)
   return QLConstant.new(self, symbol, qualifier)
end

function Constant:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics::dql::Constant "))
   indentation:insert(self:get_name())
   indentation:insert(String:string_factory(")"))
end

function Constant:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics::dql::Constant "))
   indentation:insert(self:get_name())
   indentation:insert(String:string_factory(")"))
end

return Constant
