local function output_indented(indent, s)
   retval =  string.gsub(s, "\n", "\n" .. string.rep(" ", indent * 4))
   return retval
end

local function output_beautifully(indent, data)
   local retval
   if
         type(data) == "boolean"
      or type(data) == "nil"
      or type(data) == "number"
   then
      retval =  output_indented(indent, tostring(data))
   elseif type(data) == "string"
   then
      retval =  output_indented(
            indent
         ,  "\"" .. string.gsub(data, "\"", "\\\"") .. "\"" )
   elseif type(data) == "table"
   then
      local accu =  "{"
      local last_type =  "table"
      local first_time =  true
      for k, v in pairs(data)
      do last_type =  type(v)
         if first_time
         then
            accu =  accu .. "\n    "
            first_time =  false
         else
            accu =  accu .. "\n  , "
         end
         accu =
               accu
           ..  "["
           ..  output_beautifully(0, k)
           ..  "] = "
           ..  output_beautifully(1, v)
      end
      if last_type == "table"
      then
         accu =  accu .. "}"
      else
         accu =  accu .. " }"
      end
     retval =  output_indented(indent, accu)
   end
   return retval
end

return output_beautifully
