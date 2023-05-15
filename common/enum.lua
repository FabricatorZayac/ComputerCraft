Enum = {}

---@param self table
---@param branches table
---@return unknown
function Enum.match(self, branches)
  local label, body
  for k, v in pairs(self) do
    if k ~= "match" then
      label, body = k, v
    end
  end
  local expr = branches[label]
  if type(expr) == "function" then
    if type(body) == "table" then
      return expr(unpack(body))
    else
      return expr(body)
    end
  elseif type(expr) == "table" and type(body) == "table" then
    local args = {}
    for _, i in ipairs(expr[1]) do
      table.insert(args, body[i])
    end
    return expr[#expr](unpack(args))
  else
    return expr
  end
end

---@param tab table
---@return table
function Enum.fromtable(tab)
  tab.match = Enum.match
  return tab
end

---@param tab table
---@return table
function Enum.def(tab)
  if type(tab) ~= "table" then
    error("Expected table, received " .. type(tab))
  end
  local enum = {}
  for _, label in pairs(tab) do
    local variant_meta = {
      __metatable = "variant",
      __call = function (_, body)
        local instance = {
          [label] = body or "",
          match = Enum.match,
        }
        return setmetatable(instance, {
          __metatable = "variant_instance",
        })
      end,
    }
    local variant = {label}
    setmetatable(variant, variant_meta)
    enum[label] = variant
  end
  local enum_meta = {
    __metatable = "enum",
    __index = function(_, key)
      if enum[key] == nil then
        error("Variant " .. key .. " not found for this enum")
      end
      -- returns variant
      return enum[key]
    end,
    __newindex = function(_, key, _)
      error("Attempted to modify enum definition " .. key)
    end,
  }
  return setmetatable({
    fromtable = Enum.fromtable
  }, enum_meta)
end

return setmetatable(Enum, {
  __call = function (_, tab)
    return Enum.def(tab)
  end
})
