local Type =  require "base.type.aux.Type"

local ProofHistory =  Type:__new()


package.loaded["logics.male.ProofHistory"] =  ProofHistory
local Dict =  require "base.type.Dict"
local Indentation =  require "base.Indentation"
local String =  require "base.type.String"

function ProofHistory:new()
   local retval =  ProofHistory:__new()
   retval.history =  Dict:empty_dict_factory()
   return retval
end

function ProofHistory:get_history()
   return self.history
end

function ProofHistory:add(goal, rule)
   self:get_history().add(goal, rule)
end



function ProofHistory:__diagnose_single_line(indentation)
   indentation:insert(String:string_factory("(logics.male.ProofHistory "))
   self:get_history():__diagnose_single_line(indentation)
   indentation:insert(String:string_factory(")"))
end

function ProofHistory:__diagnose_multiple_line(indentation)
   indentation:insert(String:string_factory("(logics.male.ProofHistory"))
   local is_last_elem_multiple_line =  true

   indentation:insert_newline()
   local deeper_indentation =
      indentation:get_deeper_indentation_factory {}
   is_last_elem_multiple_line =
      self:get_history():__diagnose_complex(deeper_indentation)
   deeper_indentation:save()
   indentation:insert(String:parenthesis_off_depending_factory(is_last_elem_multiple_line))
end

return ProofHistory
