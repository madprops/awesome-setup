local naughty = require("naughty")
local utils = {}

function utils.numpad(s, n)
  s = utils.round(tonumber(s))
  local ss = s
  
  if n == 3 then
    if s < 100 then
      ss = "0"..s
    end
  end
    
  if s < 10 then
    ss = "0"..ss
  end

  return ss
end

function utils.round(n)
  return math.floor(n + 0.5)
end

function utils.round_decimal(n, p)
  return tonumber(string.format("%."..p.."f", n))
end

function utils.round_mult(num, mult)
	return math.floor(num / mult + 0.5) * mult
end

function utils.indexof(value, array)
  for i, instance in ipairs(array) do
    if array[i] == value then
      return i
    end
  end
  return -1
end

function utils.isnumber(num)
  if not tonumber(num) then
    return false
  else
    return true
  end
end

function utils.msg(txt)
  naughty.notify({text = " " .. tostring(txt) .. " "})
end

return utils