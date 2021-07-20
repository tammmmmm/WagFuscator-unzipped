local constants_lib = {}

local prefix = 'obfuscation/constants/'
local len_load = require(prefix..'numbers/lenload')
local pow_load = require(prefix..'numbers/powload')
local mul_load = require(prefix..'numbers/mulload')

function constants_lib.use_function_constants(struct)
  for iterator,instruction in ipairs(struct.instructions) do
    if (type(instruction[1])~='table' and instruction.op == 1) then
      local constant = struct.constants[instruction[2]]
      local constant_type,constant_value = type(constant.Value),constant.Value
      if constant_type == 'number' then
        if constant_value < 500 and constant_value%1==0 and constant_value >0 then
          len_load(struct,iterator)
        elseif constant_value%0.001==0 then 
            --pow_load(struct,iterator)
           mul_load(struct,iterator)
          
        end
      elseif constant_type == 'string' then

      end
    end
  end
  for i,v in pairs(struct.protos) do constants_lib.use_function_constants(v) end
end



return constants_lib