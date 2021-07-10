local utils = {}

function utils.numpad(s)
  s = tonumber(s)
  local ss = s
  
  if s < 100 then
    ss = "0"..s
  end
  
  if s < 10 then
    ss = "0"..ss
  end

  return ss
end

return utils