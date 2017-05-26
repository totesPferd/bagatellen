local Path =  (require "base.oop.obj"):__new()

function Path:new(path_str)
   local retval =  self:__new()
   local is_first_c =  true
   retval.comps =  {}
   retval.is_absolute_flag =  false
   for comp in path_str:gmatch("[^/]*")
   do if comp == ""
      then
         if is_first_c
         then
            retval.is_absolute_flag =  true
         end
      else
         table.insert(retval.comps, comp)
      end
      is_first_c =  false
   end
   return retval
end

function Path:is_absolute()
   return self.is_absolute_flag
end

function Path:get_comps()
   return self.comps
end

function Path:is_initial_seq(other)
   if #self:get_comps() < #other:get_comps()
   then
      return false
   end
   for i = 1, #other:get_comps()
   do if self:get_comps()[i] ~= other:get_comps()[i]
      then
         return false
      end
   end
   return true
end

function Path:append(other)
   for _, comp in pairs(other:get_comps())
   do table.insert(self:get_comps(), comp)
   end
end

function Path:get_string()
   local retval =  table.concat(self:get_comps(), "/")
   if self:is_absolute()
   then
      retval =  "/" .. retval
   end
   return retval
end

return Path
