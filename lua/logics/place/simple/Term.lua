local Type =  require "base.type.aux.Type"

local Term =  Type:__new()

package.loaded["logics.place.simple.Term"] =  Term

function Term:new(symbol, args)
   local retval =  self:__new()
   retval.args =  args
   retval.symbol =  symbol
   return retval
end

function Term:get_term()
   return self
end

function Term:get_variable()
end

function Term:get_val()
   return self
end

function Term:get_symbol()
   return self.symbol
end

function Term:backup()
   for sub_term in self.args:elems()
   do sub_term:backup()
   end
end

function Term:restore()
   for sub_term in self.args:elems()
   do sub_term:restore()
   end
end

function Term:equate(val)
   if val
   then
      local other_term =  val:get_term()
      if other_term
      then
         if self:get_symbol() == other_term:get_symbol()
         then
            for sub_term in self.args:elems()
            do sub_term:backup()
            end
            local equatable =  true

-- im folgenden zip verwenden sobald verfügbar!
            local other_sub_terms =  other_term.args:clone()
            for sub_term in self.args:elems()
            do local other_sub_term =  other_sub_terms:get_head()
               other_sub_terms:cut_head()
               equatable =  sub_term:equate(other_sub_term)
               if not equatable
               then break
               end
            end
            if not equatable
            then
               for sub_term in self.args:elems()
               do sub_term:restore()
               end
            end
            return equatable
         end
      end
   end
   return false
end

return Term
