require "flowctrl"

f1 = flowctrl.create()

print(f1:write("a"))
print(f1:write("b"))
print(f1:write("c"))
print(f1:read())
print(f1:read())
print(f1:read())

