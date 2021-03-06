local utils = {}

function utils.numpad(s)
  s = utils.round(tonumber(s))
  local ss = s
  
  if s < 100 then
    ss = "0"..s
  end
  
  if s < 10 then
    ss = "0"..ss
  end

  return ss
end

function utils.round(n)
  return math.floor(n + 0.5)
end

function utils.indexof(value, array)
  for i, instance in ipairs(array) do
    if array[i] == value then
      return i
    end
  end
  return -1
end

return utils