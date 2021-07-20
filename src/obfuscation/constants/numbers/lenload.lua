local string_t = {
  'n-';
  'while true do end';
  'sex()';
  'n';
  'nib';
  'balls';
  'psubad';
  'tetan';
  'tetans';
  'tetballs';
  'joeballs';
  "yo're mom big fat sus!!1!";
  'when big chungus';
  'imagine not knowing how your own product works LOL!'
}


local function len_load(struct,i) 
  local function gen_len_str(len)
    math.randomseed(os.time()+(os.clock()*10000))
    local charset = {'i','l','I','1'}
    local str=''
    while #str < len do
      str = str..string_t[math.random(#string_t)]..charset[math.random(#charset)]
    end
    str = str:sub(1,len)
    return str..'\0'
  end
  local constant_used = struct.constants[struct.instructions[i][2]]
  local string_constant
  for i,v in pairs(struct.constants) do
    if type(v.Value) == "string" and #(v.Value)-1 == constant_used.Value then
      string_constant = v.ID
    end
  end
  string_constant = string_constant or kek.constant(struct,gen_len_str(constant_used.Value))
  local old_id = struct.instructions[i].ID
  local old_register = struct.instructions[i][1]
  struct.instructions[i] = {
    ID=old_id;
    [1] = {
      op=1;
      [1] = old_register;
      [2] = string_constant;
    }; 
    [2] = {
      op=20;
      [1] = old_register;
      [2] = old_register;
    }
  }
end


return len_load