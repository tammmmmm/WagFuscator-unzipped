for i = 1,1000 do
print('\n\n\n\n\n\n\n\n\n')

end

--local prinx = print print=function() prinx(debug.traceback()) end
syn = false


local init = require('useful/libloader')
math.randomseed(10)
local obfuscate = require('obfuscation/obfuscate')
file.write('textyes',string.dump(obfuscate))
local src = [[
function eraseTerminal ()
  io.write("\27[2J")
end


-- writes an `*' at column `x' , row `y'
function mark (x,y)
  io.write(string.format("\27[%d;%dH*", y, x))
end


-- Terminal size
TermSize = {w = 80, h = 24}


-- plot a function
-- (assume that domain and image are in the range [-1,1])
function plot (f)
  eraseTerminal()
  for i=1,TermSize.w do
     local x = (i/TermSize.w)*2 - 1
     local y = (f(x) + 1)/2 * TermSize.h
     mark(i, y)
  end
  io.read()  -- wait before spoiling the screen
end


-- example
plot(function (x) return math.sin(x*2*math.pi) end)
]]

local bc,struct = obfuscate(src)
local ls = loadstring(src,'TESTNAMEYES')
local dumped_bc = string.dump(ls)
local remadels = loadstring(bc:fromhex(),'BCYES')

file.write('outhex.out',bc)
file.write("out.out",bc:fromhex())
os.execute("lua useful/chunkspy.lua out.out --brief")
os.execute("java -jar useful/unluac.jar out.out>decompiled.lua")
local x = (loadstring(bc:fromhex()))

local y= loadstring(dumped_bc)
x()
--[[function benchmark(f1,f2,count,args1,args2)
  local c1,c2 = 0,0

  for i=1,count do
    c1=c1+kek.clock_call(f1,unpack(args1))
    c2=c2+kek.clock_call(f2,unpack(args1))
  end
  local ff = (c1<c2 and 'FUNCTION 1') or (c2<c1 and 'FUNCTION 2') 
  local leader,loser = (c1<c2 and c1) or (c2<c1 and c2),(c1<c2 and c2) or (c2<c1 and c1)
  local prc = '%'
  local percentage = loser/leader 
  local pr = string.format([ [
PERFORMANCE DUMP
  FASTER FUNCTION: %s
  FUNCTION 1 TIME:%s
  FUNCTION 2 TIME:%s
  PERCENTAGE:%s %s slower
  ] ],ff,tostring(c1/count),tostring(c2/count),tostring((percentage-1)*100),prc)
  return pr
end

print(benchmark(x,y,100,{{}},{{}}))]]
