local Type =  require "base.type.aux.Type"
local Indentation =  require "base.Indentation"

function Type:__diagnose_complex(indentation)
   local deeper_indentation =  indentation:get_deeper_indentation_factory {
         indent = 0 }
   self:__diagnose_single_line(deeper_indentation)
   local retval =  deeper_indentation:is_too_wide()
   if retval
   then
      deeper_indentation = indentation:get_deeper_indentation_factory {
            indent = 0 }
      self:__diagnose_multiple_line(deeper_indentation)
   end
   deeper_indentation:save()
   return retval
end

function Type:diagnose(params)
   local indentation =  Indentation:new_factory(params)
   self:__diagnose_complex(indentation)
   indentation:save()
   return indentation:get_content()
end
