return {
  ---@param tab table 
  ---@return table
  enum = function(tab)
    local enum_meta = {
      __index = function(_, key)
        if tab[key] == nil then
            error("Variant " .. key .. " not found for this enum")
        end
        return tab[key]
      end,
      __newindex = function(_, key, _)
        error("Attempted to modify enum definition " .. key)
      end,
    }
    return setmetatable({}, enum_meta)
  end,
}
