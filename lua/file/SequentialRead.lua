local Type =  require "base.type.aux.Type"

local SequentialRead =  Type:__new()

package.loaded["file.SequentialRead"] =  SequentialRead
local Line =  require "file.Line"
local String =  require "base.type.String"

function SequentialRead:new(position)
   local retval =  self:__new()
   retval.position =  position
   retval.fd =  nil
   return retval
end

function SequentialRead:get_position()
   return self.position
end

function SequentialRead:get_filename()
   return self:get_position():get_filename()
end

function SequentialRead:open()
   self.fd =  io.open(self:get_filename())
   local retval =  false
   if self.fd
   then
      retval =  true
   end
   return retval
end

function SequentialRead:lines()
   local f, s, v =  self.fd:lines()
   function new_f(s, v)
      self:get_position():next_line()
      local old_ret =  f(s, v)
      if old_ret
      then
         return Line:new(String:string_factory(old_ret), self:get_position())
      end
   end
   return new_f, s, v
end

return SequentialRead
