local Type =  require "base.type.aux.Type"

local Transaction =  Type:__new()


package.loaded["redland.Transaction"] =  Transaction
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function Transaction:bindings_transaction_factory(bindings_transaction)
   local retval =  Transaction:__new()
   retval.val =  bindings_transaction
   return retval
end

function Transaction:get_bindings_transaction()
   return self.val
end

function Transaction:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(
         "(redland.Transaction)" ))
end

function Transaction:__diagnose_multiple_line(indentation)
   return self:__diagnose_single_line(indentation)
end

return Transaction

