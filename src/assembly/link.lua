local linkmodule = {}
math.randomseed(os.time())
--[[
  //THIS MODULE IS ESSENTIAL TO OBFUSCATIOn
  //THIS MODULE WILL TAKE A STRUCT WITH INFO
  // EXTRA ABSTRACT INFO AND LINK THEM TOGETHER
  //EX: TAKES UUIDS FOR CONSTANTS AND LINKS THEM TO INDEXES
  //EX: LINKS JMP INSTRUCTIONS TOGETHER
]]


function linkmodule.collapse_small_routines(struct)
  for iterator,instruction in pairs(struct.instructions) do
    if type(instruction[1]) == 'table' then
      local FirstInstId = instruction.ID
      instruction[1]['ID'] = FirstInstId
      for i,sub_instruction in ipairs(instruction) do
        if i~=1 and sub_instruction.ID == nil then
          sub_instruction.ID = uuid()
        end
      end
      for i=#instruction,1,-1 do
        table.insert(struct.instructions,iterator+1,instruction[i])
      end
      table.remove(struct.instructions,iterator)
    end
  end

end

function linkmodule.create_shaken_table(kst,x)
  local NewKst,NewKstTracking = {},{}
  NewKst = table.list(kst)
--[[  for i,v in pairs(table.list(kst)) do
    local index = v.OriginalIndex or #NewKst
    NewKstTracking[v.ID] = index-1
    NewKst[index] = v.Value
  
  end
  ]]
    for i,v in pairs(table.list(kst)) do
    NewKstTracking[v.ID] = i-1
    NewKst[i] = (v.Value) or v
    end

  return NewKst,NewKstTracking
end


function linkmodule.link_constants(InstructionList,Constants,ConstantInfo)

  function GenericBxKstFunc(inst)
    inst[2] = ConstantInfo[inst[2]]
    return inst
  end
  function Ignore(inst)
    return inst
  end
  local primativeSwitch = {
    [1] = GenericBxKstFunc;
    [5] = GenericBxKstFunc;
    [7] = GenericBxKstFunc;
    [22] = Ignore;
    [31] = Ignore;
    [32] = Ignore;
  }
  for instructionindex,instruction in pairs(InstructionList) do
    if primativeSwitch[instruction.op] then
      InstructionList[instructionindex] = primativeSwitch[instruction.op](instruction)
    else
      for opidx,op in ipairs(instruction) do --optimise this before release cause it takes up so much of our time wait no it doesnt it might tbh
        if type(op) == 'string' then
          if ConstantInfo[op] then
            InstructionList[instructionindex][opidx] = ConstantInfo[op]+256
          end
        end
      end
    end
  end
  return InstructionList
end

function linkmodule.link_instructions(InstructionList)
local ids = {}
local z = 1
for i,v in ipairs(InstructionList) do
  ids[v.ID] = z
  z=z+1
end
  for i,v in pairs(InstructionList) do
    local Instruction = v

      local primativeSwitch = {
        [22] = function()
          if type(Instruction[1]) ~= 'string' then return Instruction end
          Instruction[1] = -(i-ids[Instruction[1]])-1

          return Instruction
        end;
        [31] = function()
          if type(Instruction[2]) ~= 'string' then return Instruction end
          Instruction[2] = -(i-ids[Instruction[2]])-1
          return Instruction

        end;
        [32] = function()
          if type(Instruction[2]) ~= 'string' then return Instruction end
          Instruction[2] = -(i-ids[Instruction[2]])-1
          return Instruction

        end;
        ['default'] = function()
          return Instruction
        end
      }

     if primativeSwitch[Instruction.op] then
    InstructionList[i] =  primativeSwitch[Instruction.op]()
    end
    InstructionList[i].OriginalIndex = nil
    --InstructionList[i].ID = nil
  end
  return InstructionList
end

function linkmodule.link_protos(instructions,protos,proto_list)
  for i,Instruction in pairs(instructions) do
    if Instruction.op == 36 then
      Instruction[2] = proto_list[Instruction[2]]
    end
  end
end

function linkmodule.link_struct(info)
  if info.info.user_defined == true then return info end
  local const_linked,const_info = linkmodule.create_shaken_table(info.constants)
  local proto_linked,proto_info = 
  linkmodule.create_shaken_table(info.protos,true)
  info.constants = const_linked
  
  info.protos = proto_linked
  linkmodule.collapse_small_routines(info)
  linkmodule.link_constants(info.instructions,const_linked,const_info)
  linkmodule.link_instructions(info.instructions)
  linkmodule.link_protos(info.instructions,proto_linked,proto_info)
  for i,v in pairs(info.protos) do
    info.protos[i] = linkmodule.link_struct(v)
  end
  return info
end

return linkmodule