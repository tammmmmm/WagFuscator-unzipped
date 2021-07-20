local function mul_load(struct,i)
  local save_instruction = struct.instructions[i]
  local constant_used = struct.constants[struct.instructions[i][2]].Value
  local new_const = kek.constant(struct,constant_used/4)
  local four_const = kek.constant(struct,4)
  struct.instructions[i] = {
    op=14;
    [1] = save_instruction[1];
    [2] = new_const;
    [3] = four_const;
    ID = save_instruction.ID
  }
end

return mul_load