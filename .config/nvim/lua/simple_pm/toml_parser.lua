---@class TomlParser
local M = {}

---Trims whitespace from both ends of a string
---@param str string
---@return string
local function trim(str)
  return str:match '^%s*(.-)%s*$'
end

---Parses a TOML string value, handling quotes
---@param value string
---@return string
local function parse_string_value(value)
  value = trim(value)
  -- Remove surrounding quotes (single or double)
  if value:match "^'.*'$" or value:match '^".*"$' then
    return value:sub(2, -2)
  end
  return value
end

---Parses a TOML array value
---@param value string
---@return string[]
local function parse_array_value(value)
  value = trim(value)

  -- Remove surrounding brackets
  if not (value:match '^%[.*%]$') then
    error('Invalid array format: ' .. value)
  end

  value = value:sub(2, -2) -- Remove [ and ]
  local result = {}

  if trim(value) == '' then
    return result
  end

  -- Split by comma, handling quoted strings
  local current = ''
  local in_quotes = false
  local quote_char = nil

  for i = 1, #value do
    local char = value:sub(i, i)

    if not in_quotes then
      if char == '"' or char == "'" then
        in_quotes = true
        quote_char = char
        current = current .. char
      elseif char == ',' then
        if trim(current) ~= '' then
          result[#result + 1] = parse_string_value(current)
        end
        current = ''
      else
        current = current .. char
      end
    else
      current = current .. char
      if char == quote_char and (i == 1 or value:sub(i - 1, i - 1) ~= '\\') then
        in_quotes = false
        quote_char = nil
      end
    end
  end

  -- Add the last item
  if trim(current) ~= '' then
    result[#result + 1] = parse_string_value(current)
  end

  return result
end

---Parses a TOML file content
---@param content string The TOML file content
---@return table parsed The parsed TOML data
function M.parse(content)
  local result = {}
  local current_table = nil
  local current_array = nil
  local multiline_key = nil
  local multiline_value = ''

  local lines = {}
  for line in content:gmatch '[^\r\n]+' do
    lines[#lines + 1] = line
  end

  for line_num, line in ipairs(lines) do
    local trimmed_line = trim(line)

    -- Skip empty lines and comments (but not during multiline array parsing)
    if not multiline_key and (trimmed_line == '' or trimmed_line:match '^#') then
      goto continue
    end

    -- Handle multiline arrays
    if multiline_key then
      multiline_value = multiline_value .. ' ' .. trimmed_line

      -- Check if array is complete (ends with ])
      local bracket_count = 0
      for i = 1, #multiline_value do
        local char = multiline_value:sub(i, i)
        if char == '[' then
          bracket_count = bracket_count + 1
        elseif char == ']' then
          bracket_count = bracket_count - 1
        end
      end

      if bracket_count == 0 then
        -- Array is complete, parse it
        local target = current_table or result
        target[multiline_key] = parse_array_value(multiline_value)
        multiline_key = nil
        multiline_value = ''
      end
      goto continue
    end

    -- Handle table headers [table] or [[array_of_tables]]
    local table_match = trimmed_line:match '^%[%[(.-)%]%]$'
    if table_match then
      -- Array of tables
      local table_name = trim(table_match)
      if not result[table_name] then
        result[table_name] = {}
      end
      local new_table = {}
      table.insert(result[table_name], new_table)
      current_table = new_table
      current_array = table_name
      goto continue
    end

    table_match = trimmed_line:match '^%[(.-)%]$'
    if table_match then
      -- Regular table
      local table_name = trim(table_match)
      result[table_name] = result[table_name] or {}
      current_table = result[table_name]
      current_array = nil
      goto continue
    end

    -- Handle key-value pairs
    local key, value = trimmed_line:match '^([^=]+)%s*=%s*(.+)$'
    if key and value then
      key = trim(key)
      value = trim(value)

      local target = current_table or result

      if value:match '^%[' then
        -- Array value (might be multiline)
        local bracket_count = 0
        for i = 1, #value do
          local char = value:sub(i, i)
          if char == '[' then
            bracket_count = bracket_count + 1
          elseif char == ']' then
            bracket_count = bracket_count - 1
          end
        end

        if bracket_count == 0 then
          -- Complete array on one line
          target[key] = parse_array_value(value)
        else
          -- Start of multiline array
          multiline_key = key
          multiline_value = value
        end
      else
        -- String value
        target[key] = parse_string_value(value)
      end
      goto continue
    end

    -- If we get here and we're not in multiline mode, it's an invalid line
    if not multiline_key then
      error(string.format('Invalid TOML syntax at line %d: %s', line_num, trimmed_line))
    end

    ::continue::
  end

  return result
end

---Reads and parses a TOML file
---@param filepath string Path to the TOML file
---@return table parsed The parsed TOML data
function M.parse_file(filepath)
  local file = io.open(filepath, 'r')
  if not file then
    error('Cannot open file: ' .. filepath)
  end

  local content = file:read '*all'
  file:close()

  return M.parse(content)
end

---Parses plugins.toml specifically and returns a PluginConfig
---@param filepath string Path to the plugins.toml file
---@return PluginConfig config The parsed plugin configuration
function M.parse_plugins_toml(filepath)
  local data = M.parse_file(filepath)

  if not data.plugins then
    error 'plugins.toml must contain a [[plugins]] section'
  end

  return {
    plugins = data.plugins,
  }
end

return M
