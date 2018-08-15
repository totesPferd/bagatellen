local URITemplate =  require "base.structure.uritemplate"

local test_cases =  {{
            ["send"] = {
                  ["var"] = "value"
               ,  ["hello"] = "Hello World!" }
         ,  ["expect"] = {
                  ["{var}"] = "value"
               ,  ["{hello}"] = "Hello%20World%21" }}
   ,  {     ["send"] = {
                  ["var"] = "value"
               ,  ["hello"] = "Hello World!"
               ,  ["path"] = "/foo/bar" }
         ,  ["expect"] = {
                  ["{+var}"] = "value"
               ,  ["{+hello}"] = "Hello%20World!"
               ,  ["{+path}/here"] = "/foo/bar/here"
               ,  ["here?ref={+path}"] = "here?ref=/foo/bar"
               ,  ["X{#var}"] = "X#value"
               ,  ["X{#hello}"] = "X#Hello%20World!" }}
   ,  {     ["send"] = {
                  ["var"] = "value"
               ,  ["hello"] = "Hello World!"
               ,  ["empty"] = ""
               ,  ["path"] = "/foo/bar"
               ,  ["x"] = "1024"
               ,  ["y"] = "768" }
         ,  ["expect"] = {
                  ["map?{x,y}"] = "map?1024,768"
               ,  ["{x,hello,y}"] = "1024,Hello%20World%21,768"
               ,  ["{+x,hello,y}"] = "1024,Hello%20World!,768"
               ,  ["{+path,x}/here"] = "/foo/bar,1024/here"
               ,  ["{#x,hello,y}"] = "#1024,Hello%20World!,768"
               ,  ["{#path,x}/here"] = "#/foo/bar,1024/here"
               ,  ["X{.var}"] = "X.value"
               ,  ["X{.x,y}"] = "X.1024.768"
               ,  ["{/var}"] = "/value"
               ,  ["{/var,x}/here"] = "/value/1024/here"
               ,  ["{;x,y}"] = ";x=1024;y=768"
               ,  ["{;x,y,empty}"] = ";x=1024;y=768;empty"
               ,  ["{?x,y}"] = "?x=1024&y=768"
               ,  ["{?x,y,empty}"] = "?x=1024&y=768&empty="
               ,  ["?fixed=yes{&x}"] = "?fixed=yes&x=1024"
               ,  ["{&x,y,empty}"] = "&x=1024&y=768&empty=" }}
   ,  {     ["send"] = {
                  ["var"] = "value"
               ,  ["hello"] = "Hello World!"
               ,  ["path"] = "/foo/bar"
               ,  ["list"] = { "red", "green", "blue" }
               ,  ["keys"] = {
                        ["semi"] = ";"
                     ,  ["dot"] = "."
                     ,  ["comma"] = "," }}
         ,  ["expect"] = {
                  ["{var:3}"] = "val"
               ,  ["{var:30}"] = "value"
               ,  ["{list}"] = "red,green,blue"
               ,  ["{list*}"] = "red,green,blue"
               ,  ["{keys}"] = {
                        regex = "(.+),(.+),(.+),(.+),(.+),(.+)"
                     ,  result = "semi,%3B,dot,.,comma,%2C" }
               ,  ["{keys*}"] = {
                        regex = "(.+)=(.+),(.+)=(.+),(.+)=(.+)"
                     ,  result = "semi=%3B,dot=.,comma=%2C" }
               ,  ["{+path:6}/here"] = "/foo/b/here"
               ,  ["{+list}"] = "red,green,blue"
               ,  ["{+list*}"] = "red,green,blue"
               ,  ["{+keys}"] = {
                        regex = "(.+),(.+),(.+),(.+),(.+),(.+)"
                     ,  result = "semi,;,dot,.,comma,," }
               ,  ["{+keys*}"] = {
                        regex = "(.+)=(.+),(.+)=(.+),(.+)=(.+)"
                     ,  result = "semi=;,dot=.,comma=," }
               ,  ["{#path:6}/here"] = "#/foo/b/here"
               ,  ["{#list}"] = "#red,green,blue"
               ,  ["{#list*}"] = "#red,green,blue"
               ,  ["{#keys}"] = {
                        regex = "#(.+),(.+),(.+),(.+),(.+),(.+)"
                     ,  result = "#semi,;,dot,.,comma,," }
               ,  ["{#keys*}"] = {
                        regex = "#(.+)=(.+),(.+)=(.+),(.+)=(.+)"
                     ,  result = "#semi=;,dot=.,comma=," }
               ,  ["X{.var:3}"] = "X.val"
               ,  ["X{.list}"] = "X.red,green,blue"
               ,  ["X{.list*}"] = "X.red.green.blue"
               ,  ["X{.keys}"] = {
                        regex = "X.(.+),(.+),(.+),(.+),(.+),(.+)"
                     ,  result = "X.semi,%3B,dot,.,comma,%2C" }
               ,  ["X{.keys*}"] = {
                        regex = "X%.(.+)=(.+)%.(.+)=(.+)%.(.+)=(.+)"
                     ,  result = "X.semi=%3B.dot=..comma=%2C" }
               ,  ["{/var:1,var}"] = "/v/value"
               ,  ["{/list}"] = "/red,green,blue"
               ,  ["{/list*}"] = "/red/green/blue"
               ,  ["{/list*,path:4}"] = "/red/green/blue/%2Ffoo"
               ,  ["{/keys}"] = {
                        regex = "/(.+),(.+),(.+),(.+),(.+),(.+)"
                     ,  result = "/semi,%3B,dot,.,comma,%2C" }
               ,  ["{/keys*}"] = {
                        regex = "/(.+)=(.+)/(.+)=(.+)/(.+)=(.+)"
                     ,  result = "/semi=%3B/dot=./comma=%2C" }
               ,  ["{;hello:5}"] = ";hello=Hello"
               ,  ["{;list}"] = ";list=red,green,blue"
               ,  ["{;list*}"] = ";list=red;list=green;list=blue"
               ,  ["{;keys}"] = {
                        regex = ";keys=(.+),(.+),(.+),(-+),(.+),(.+)"
                     ,  result = ";keys=semi,%3B,dot,.,comma,%2C" }
               ,  ["{;keys*}"] = {
                        regex = ";(.+)=(.+);(.+)=(.+);(.+)=(.+)"
                     ,  result = ";semi=%3B;dot=.;comma=%2C" }
               ,  ["{?var:3}"] = "?var=val"
               ,  ["{?list}"] = "?list=red,green,blue"
               ,  ["{?list*}"] = "?list=red&list=green&list=blue"
               ,  ["{?keys}"] = {
                        regex = "?keys=(.+),(.+),(.+),(.+),(.+),(.+)"
                     ,  result = "?keys=semi,%3B,dot,.,comma,%2C" }
               ,  ["{?keys*}"] = {
                        regex = "?(.+)=(.+)&(.+)=(.+)&(.+)=(.+)"
                     ,  result = "?semi=%3B&dot=.&comma=%2C" }
               ,  ["{&var:3}"] = "&var=val"
               ,  ["{&list}"] = "&list=red,green,blue"
               ,  ["{&list*}"] = "&list=red&list=green&list=blue"
               ,  ["{&keys}"] = {
                        regex = "&keys=(.+),(.+),(.+),(.+),(.+),(.+)"
                     ,  result = "&keys=semi,%3B,dot,.,comma,%2C" }
               ,  ["{&keys*}"] = {
                        regex = "&(.+)=(.+)&(.+)=(.+)&(.+)=(.+)"
                     ,  result = "&semi=%3B&dot=.&comma=%2C" }}}
   ,  {     ["send"] = {
                  ["var"] = "value"
               ,  ["semi"] = ";" }
         ,  ["expect"] = {
                  ["{var}"] = "value"
               ,  ["{var:20}"] = "value"
               ,  ["{var:3}"] = "val"
               ,  ["{semi}"] = "%3B"
               ,  ["{semi:2}"] = "%3B" }}
   ,  {     ["send"] = {
                  ["year"] = { "1965", "2000", "2012" }
               ,  ["dom"] = { "example", "com" }}
         ,  ["expect"] = {
                  ["find{?year*}"] = "find?year=1965&year=2000&year=2012"
               ,  ["www{.dom*}"] = "www.example.com" }}
   ,  {     ["send"] = {
                   ["count"] = { "one", "two", "three" }
                ,  ["dom"] = { "example", "com" }
                ,  ["dub"] = "me/too"
                ,  ["hello"] = "Hello World!"
                ,  ["half"] = "50%"
                ,  ["var"] = "value"
                ,  ["who"] = "fred"
                ,  ["base"] = "http://example.com/home/"
                ,  ["path"] = "/foo/bar"
                ,  ["list"] = { "red", "green", "blue" }
                ,  ["keys"] = {
                         ["semi"] = ";"
                      ,  ["dot"] = "."
                      ,  ["comma"] = "," }
                ,  ["v"] = "6"
                ,  ["x"] = "1024"
                ,  ["y"] = "768"
                ,  ["empty"] = ""
                ,  ["empty_keys"] = {}
                ,  ["undef"] = nil }
         ,  ["expect"] = {
                   ["{count}"] = "one,two,three"
                ,  ["{count*}"] = "one,two,three"
                ,  ["{/count}"] = "/one,two,three"
                ,  ["{/count*}"] = "/one/two/three"
                ,  ["{;count}"] = ";count=one,two,three"
                ,  ["{;count*}"] = ";count=one;count=two;count=three"
                ,  ["{?count}"] = "?count=one,two,three"
                ,  ["{?count*}"] = "?count=one&count=two&count=three"
                ,  ["{&count*}"] = "&count=one&count=two&count=three"
                ,  ["{var}"] = "value"
                ,  ["{hello}"] = "Hello%20World%21"
                ,  ["{half}"] = "50%25"
                ,  ["O{empty}X"] = "OX"
                ,  ["O{undef}X"] = "OX"
                ,  ["{x,y}"] = "1024,768"
                ,  ["{x,hello,y}"] = "1024,Hello%20World%21,768"
                ,  ["?{x,empty}"] = "?1024,"
                ,  ["?{x,undef}"] = "?1024"
                ,  ["?{undef,y}"] = "?768"
                ,  ["{var:3}"] = "val"
                ,  ["{var:30}"] = "value"
                ,  ["{list}"] = "red,green,blue"
                ,  ["{list*}"] = "red,green,blue"
                ,  ["{keys}"] = {
                         regex = "(.+),(.+),(.+),(.+),(.+),(.+)"
                      ,  result = "semi,%3B,dot,.,comma,%2C" }
                ,  ["{keys*}"] = {
                         regex = "(.+)=(.+),(.+)=(.+),(.+)=(.+)"
                      ,  result = "semi=%3B,dot=.,comma=%2C" }
                ,  ["{+var}"] = "value"
                ,  ["{+hello}"] = "Hello%20World!"
                ,  ["{+half}"] = "50%25"
                ,  ["{base}index"] = "http%3A%2F%2Fexample.com%2Fhome%2Findex"
                ,  ["{+base}index"] = "http://example.com/home/index"
                ,  ["O{+empty}X"] = "OX"
                ,  ["O{+undef}X"] = "OX"
                ,  ["{+path}/here"] = "/foo/bar/here"
                ,  ["here?ref={+path}"] = "here?ref=/foo/bar"
                ,  ["up{+path}{var}/here"] = "up/foo/barvalue/here"
                ,  ["{+x,hello,y}"] = "1024,Hello%20World!,768"
                ,  ["{+path,x}/here"] = "/foo/bar,1024/here"
                ,  ["{+path:6}/here"] = "/foo/b/here"
                ,  ["{+list}"] = "red,green,blue"
                ,  ["{+list*}"] = "red,green,blue"
                ,  ["{+keys}"] = {
                         regex = "(.+),(.+),(.+),(.+),(.+),(.+)"
                      ,  result = "semi,;,dot,.,comma,," }
                ,  ["{+keys*}"] = {
                         regex = "(.+)=(.+),(.+)=(.+),(.+)=(.+)"
                      ,  result = "semi=;,dot=.,comma=," }
                ,  ["{#var}"] = "#value"
                ,  ["{#hello}"] = "#Hello%20World!"
                ,  ["{#half}"] = "#50%25"
                ,  ["foo{#empty}"] = "foo#"
                ,  ["foo{#undef}"] = "foo"
                ,  ["{#x,hello,y}"] = "#1024,Hello%20World!,768"
                ,  ["{#path,x}/here"] = "#/foo/bar,1024/here"
                ,  ["{#path:6}/here"] = "#/foo/b/here"
                ,  ["{#list}"] = "#red,green,blue"
                ,  ["{#list*}"] = "#red,green,blue"
                ,  ["{#keys}"] = {
                         regex = "#(.+),(.+),(.+),(.+),(.+),(.+)"
                      ,  result = "#semi,;,dot,.,comma,," }
                ,  ["{#keys*}"] = {
                         regex = "#(.+)=(.+),(.+)=(.+),(.+)=(.+)"
                      ,  result = "#semi=;,dot=.,comma=," }
                ,  ["{.who}"] = ".fred"
                ,  ["{.who,who}"] = ".fred.fred"
                ,  ["{.half,who}"] = ".50%25.fred"
                ,  ["www{.dom*}"] = "www.example.com"
                ,  ["X{.var}"] = "X.value"
                ,  ["X{.empty}"] = "X."
                ,  ["X{.undef}"] = "X"
                ,  ["X{.var:3}"] = "X.val"
                ,  ["X{.list}"] = "X.red,green,blue"
                ,  ["X{.list*}"] = "X.red.green.blue"
                ,  ["X{.keys}"] = {
                         regex = "X.(.+),(.+),(.+),(.+),(.+),(.+)"
                      ,  result = "X.semi,%3B,dot,.,comma,%2C" }
                ,  ["X{.keys*}"] = {
                         regex = "X%.(.+)=(.+)%.(.+)=(.+)%.(.+)=(.+)"
                      ,  result = "X.semi=%3B.dot=..comma=%2C" }
                ,  ["X{.empty_keys}"] = "X"
                ,  ["X{.empty_keys*}"] = "X"
                ,  ["{/who}"] = "/fred"
                ,  ["{/who,who}"] = "/fred/fred"
                ,  ["{/half,who}"] = "/50%25/fred"
                ,  ["{/who,dub}"] = "/fred/me%2Ftoo"
                ,  ["{/var}"] = "/value"
                ,  ["{/var,empty}"] = "/value/"
                ,  ["{/var,undef}"] = "/value"
                ,  ["{/var,x}/here"] = "/value/1024/here"
                ,  ["{/var:1,var}"] = "/v/value"
                ,  ["{/list}"] = "/red,green,blue"
                ,  ["{/list*}"] = "/red/green/blue"
                ,  ["{/list*,path:4}"] = "/red/green/blue/%2Ffoo"
                ,  ["{/keys}"] = {
                         regex = "/(.+),(.+),(.+),(.+),(.+),(.+)"
                      ,  result = "/semi,%3B,dot,.,comma,%2C" }
                ,  ["{/keys*}"] = {
                         regex = "/(.+)=(.+)/(.+)=(.+)/(.+)=(.+)"
                      ,  result = "/semi=%3B/dot=./comma=%2C" }
                ,  ["{;who}"] = ";who=fred"
                ,  ["{;half}"] = ";half=50%25"
                ,  ["{;empty}"] = ";empty"
                ,  ["{;v,empty,who}"] = ";v=6;empty;who=fred"
                ,  ["{;v,bar,who}"] = ";v=6;who=fred"
                ,  ["{;x,y}"] = ";x=1024;y=768"
                ,  ["{;x,y,empty}"] = ";x=1024;y=768;empty"
                ,  ["{;x,y,undef}"] = ";x=1024;y=768"
                ,  ["{;hello:5}"] = ";hello=Hello"
                ,  ["{;list}"] = ";list=red,green,blue"
                ,  ["{;list*}"] = ";list=red;list=green;list=blue"
                ,  ["{;keys}"] = {
                         regex = ";keys=(.+),(.+),(.+),(.+),(.+),(.+)"
                      ,  result = ";keys=semi,%3B,dot,.,comma,%2C" }
                ,  ["{;keys*}"] = {
                         regex = ";(.+)=(.+);(.+)=(.+);(.+)=(.+)"
                      ,  result = ";semi=%3B;dot=.;comma=%2C" }
                ,  ["{?who}"] = "?who=fred"
                ,  ["{?half}"] = "?half=50%25"
                ,  ["{?x,y}"] = "?x=1024&y=768"
                ,  ["{?x,y,empty}"] = "?x=1024&y=768&empty="
                ,  ["{?x,y,undef}"] = "?x=1024&y=768"
                ,  ["{?var:3}"] = "?var=val"
                ,  ["{?list}"] = "?list=red,green,blue"
                ,  ["{?list*}"] = "?list=red&list=green&list=blue"
                ,  ["{?keys}"] = {
                         regex = "?keys=(.+),(.+),(.+),(.+),(.+),(.+)"
                      ,  result = "?keys=semi,%3B,dot,.,comma,%2C" }
                ,  ["{?keys*}"] = {
                         regex = "?(.+)=(.+)&(.+)=(.+)&(.+)=(.+)"
                      ,  result = "?semi=%3B&dot=.&comma=%2C" }
                ,  ["{&who}"] = "&who=fred"
                ,  ["{&half}"] = "&half=50%25"
                ,  ["?fixed=yes{&x}"] = "?fixed=yes&x=1024"
                ,  ["{&x,y,empty}"] = "&x=1024&y=768&empty="
                ,  ["{&x,y,undef}"] = "&x=1024&y=768"
                ,  ["{&var:3}"] = "&var=val"
                ,  ["{&list}"] = "&list=red,green,blue"
                ,  ["{&list*}"] = "&list=red&list=green&list=blue"
                ,  ["{&keys}"] = {
                         regex = "&keys=(.+),(.+),(.+),(.+),(.+),(.+)"
                      ,  result = "&keys=semi,%3B,dot,.,comma,%2C" }
                ,  ["{&keys*}"] =  {
                         regex = "&(.+)=(.+)&(.+)=(.+)&(.+)=(.+)"
                      ,  result = "&semi=%3B&dot=.&comma=%2C" }}}
}

local function list_to_dict(l)
   local mode =  "key"
   local key =  nil
   local retval =  {}
   for k, v in pairs(l)
   do if mode == "key"
      then
         key =  v
         mode =  "val"
      else
         retval[key] =  v
         mode =  "key"
      end
   end
   return retval
end

local function eq_dict(x, y)
   for k, v in pairs(x)
   do if y[k] ~= v
      then
         return false
      end
   end
   for k, v in pairs(y)
   do if x[k] ~= v
      then
         return false
      end
   end
   return true
end


for nr, test_case in pairs(test_cases)
do for s, e in pairs(test_case.expect)
   do local t =  URITemplate:new(s)
      local result =  t:instantiate(test_case.send)
      local is_ok =  false
      local exp =  nil 
      if type(e) == "string"
      then
         is_ok = (result == e)
         exp =  e
      elseif type(e) == "table"
      then
         a_res =  list_to_dict { string.match(result, e.regex) }
         b_res =  list_to_dict { string.match(e.result, e.regex) }
         is_ok =  eq_dict(a_res, b_res)
         exp =  e.result
      end
      if not(is_ok)
      then
         io.stdout:write("test case #")
         io.stdout:write(tostring(nr))
         io.stdout:write(", send: \"")
         io.stdout:write(s)
         io.stdout:write("\", result: \"")
         io.stdout:write(result)
         io.stdout:write("\", expected: \"")
         io.stdout:write(exp)
         io.stdout:write("\"\n")
      end
   end
end
