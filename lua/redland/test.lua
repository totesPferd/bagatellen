local Node           =  require "redland.Node"
local BlankNode      =  require "redland.BlankNode"
local LiteralNode    =  require "redland.LiteralNode"
local Node           =  require "redland.Node"
local Stmt           =  require "redland.Stmt"
local Uri            =  require "redland.Uri"
local UriNode        =  require "redland.UriNode"
local World          =  require "redland.World"

local world =  World:new()

print("***  Checking URI Module  ***")
local filename =  "doll.c"
local uri_1 =  Uri:filename_factory(world, filename)
print("uri_1", uri_1:diagnose {})

local uri_2 =  uri_1:__clone()
print("uri_2", uri_2:diagnose {})

local uri_3_1 =  Uri:new(world, "http://www.google.com")
local uri_3_2 =  Uri:new(world, "http://www.yandex.com")
local rel_uri_3 =  "/search/search_engines"
print("uri_3_1", uri_3_1:diagnose {})
print("uri_3_2", uri_3_2:diagnose {})

local uri_4_1 =  Uri:local_name_factory(uri_3_1, rel_uri_3)
local uri_4_2 =  Uri:normalized_to_base_factory(
      uri_3_1
   ,  uri_3_2
   ,  tostring(uri_4_1) )
print("uri_4_1", uri_4_1:diagnose {})
print("uri_4_2", uri_4_2:diagnose {})

local uri_5_3 =  Uri:relative_to_base_factory(
      uri_3_2
   ,  "/not_found" )
print("uri_5_3", uri_5_3:diagnose {})

local l_1 =  { uri_1, uri_2, uri_3_1, uri_3_2, uri_4_1, uri_4_2, uri_5_3 }
print()
print(" ... vor dem Sortieren")
for k, v in pairs(l_1)
do print(v:diagnose {})
end
table.sort(l_1)
print()
print(" ... nach dem Sortieren")
for k, v in pairs(l_1)
do local filename =  v:get_filename()
   print(v:diagnose {}, filename == nil, filename)
end

print()
print()
print("***  Checking Node Module  ***")

local node_1 =  BlankNode:new(world)
local node_2 =  UriNode:new(world, uri_5_3)
local node_3 =  LiteralNode:new(world, {
      value =  "zwoelf" })

local blank_str_1 =  node_1:get_blank_node():get_id()
print("blank_str_1", blank_str_1)
local node_4 =  BlankNode:new(world, blank_str_1)
print(node_2:get_blank_node() == nil)
print(node_3:get_blank_node() == nil)
print(node_1:get_uri_node() == nil)
local resource_2 =  node_2:get_uri_node():get_uri()
print("resource_2", resource_2:diagnose {})
print(node_3:get_uri_node() == nil)
print(node_1:get_literal_node() == nil)
print(node_2:get_literal_node() == nil)
for k, v in pairs(node_3:get_literal_node())
do print(k, v)
end

print("node_1", node_1:diagnose {})
print("node_2", node_2:diagnose {})
print("node_3", node_3:diagnose {})
print("node_4", node_4:diagnose {})

print()
print()
print("***  Checking Stmt Module  ***")
 
local stmt_1 =  Stmt:new(world)
print(stmt_1:get_object() == nil)
print(stmt_1:get_predicate() == nil)
print(stmt_1:get_subject() == nil)
print(stmt_1:is_complete())
local stmt_2 =  stmt_1:__clone()
stmt_1:set_object(node_3)
stmt_1:set_predicate(node_2)
stmt_1:set_subject(node_1)
print(stmt_1:get_object() == nil)
print(stmt_1:get_predicate() == nil)
print(stmt_1:get_subject() == nil)
print(stmt_1:is_complete())
print(stmt_1:is_match(stmt_2))
print(stmt_1 == stmt_2)
 
print()
print()
print("***  Checking Store Module  ***")

-- for idx = 0,11
-- do local lookup =  redland_module.store.lookup(world, idx)
--    if lookup
--    then
--       for k, v in pairs(lookup)
--       do print(k, v)
--       end
--    end
-- end
