local Type =  require "base.type.aux.Type"

local Line =  Type:__new()

package.loaded["file.Line"] =  Line

function Line:new(line, position)
   local retval =  Line:__new()
   retval.line =  line
   retval.position =  position
   return retval
end

function Line:get_position()
   return self.position
end

function Line:chars()
   local f, s, v =  self.line:chars()
   function new_f(s, v)
      self:get_position():next_col()
      return f(s, v)
   end
   return new_f, s, v
end

return Line
