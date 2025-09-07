local M = {}

--- Safely loads a Lua file and returns its result
--- @param filepath string The path to the Lua file
--- @return any|nil The result of loading the file, or nil if failed
--- @return string|nil Error message if loading failed
local function safe_load_file(filepath)
  local success, result = pcall(dofile, filepath)
  if success then
    return result, nil
  else
    return nil, result
  end
end

--- Checks if a path is a Lua file
--- @param filepath string The path to check
--- @return boolean True if the file has .lua extension
local function is_lua_file(filepath)
  return filepath:match '%.lua$' ~= nil
end

--- Recursively walks through a directory and safely loads all Lua files
--- @param directory string The directory path to walk through
--- @param callback function|nil Optional callback function called for each loaded file: callback(filepath, result, error)
--- @return table Array of results: {filepath, result, error}
function M.load_lua_files(directory, callback)
  local results = {}

  -- Ensure directory exists
  if vim.fn.isdirectory(directory) ~= 1 then
    error('Directory does not exist or is not a directory: ' .. directory)
  end

  --- Recursive function to walk directory
  local function walk_directory(path)
    -- Use vim.fn.readdir to get directory contents
    local items = vim.fn.readdir(path)

    for _, item in ipairs(items) do
      local full_path = path .. '/' .. item

      if vim.fn.isdirectory(full_path) == 1 then
        -- Recursively walk subdirectories
        walk_directory(full_path)
      elseif vim.fn.filereadable(full_path) == 1 and is_lua_file(full_path) then
        -- Load Lua file safely
        local result, error = safe_load_file(full_path)
        local entry = {
          filepath = full_path,
          result = result,
          error = error,
        }

        table.insert(results, entry)

        -- Call callback if provided
        if callback then
          callback(full_path, result, error)
        end
      end
    end
  end

  walk_directory(directory)
  return results
end

--- Safely loads all Lua files from a directory with error handling
--- @param directory string The directory path to walk through
--- @param options table|nil Optional configuration: {silent = false, filter = function}
--- @return table Results with successful and failed loads
function M.load_lua_files_safe(directory, options)
  options = options or {}
  local silent = options.silent or false
  local filter = options.filter

  local successful = {}
  local failed = {}

  local callback = function(filepath, result, error)
    if error then
      table.insert(failed, { filepath = filepath, error = error })
      if not silent then
        vim.notify('Failed to load ' .. filepath .. ': ' .. error, vim.log.levels.WARN)
      end
    else
      -- Apply filter if provided
      if not filter or filter(filepath, result) then
        table.insert(successful, { filepath = filepath, result = result })
      end
    end
  end

  local results = M.load_lua_files(directory, callback)

  return {
    successful = successful,
    failed = failed,
    total = #results,
    success_count = #successful,
    failure_count = #failed,
  }
end

--- Get all Lua files in a directory (without loading them)
--- @param directory string The directory path to scan
--- @param recursive boolean|nil Whether to scan recursively (default: true)
--- @return table Array of Lua file paths
function M.get_lua_files(directory, recursive)
  recursive = recursive == nil and true or recursive

  if vim.fn.isdirectory(directory) ~= 1 then
    error('Directory does not exist or is not a directory: ' .. directory)
  end

  local files = {}

  local function scan_directory(path)
    local items = vim.fn.readdir(path)

    for _, item in ipairs(items) do
      local full_path = path .. '/' .. item

      if vim.fn.isdirectory(full_path) == 1 and recursive then
        scan_directory(full_path)
      elseif vim.fn.filereadable(full_path) == 1 and is_lua_file(full_path) then
        table.insert(files, full_path)
      end
    end
  end

  scan_directory(directory)
  return files
end

--- Check if a file exists and is readable
--- @param filepath string The file path to check
--- @return boolean True if file exists and is readable
function M.file_exists(filepath)
  return vim.fn.filereadable(filepath) == 1
end

--- Get file modification time
--- @param filepath string The file path
--- @return number|nil Modification time or nil if file doesn't exist
function M.get_mtime(filepath)
  if not M.file_exists(filepath) then
    return nil
  end
  return vim.fn.getftime(filepath)
end

--- Get relative path from a base directory
--- @param filepath string The full file path
--- @param basedir string The base directory
--- @return string The relative path
function M.get_relative_path(filepath, basedir)
  return vim.fn.fnamemodify(filepath, ':s?' .. vim.fn.escape(basedir, '?') .. '/??')
end

--- Get file name without extension
--- @param filepath string The file path
--- @return string The file name without extension
function M.get_basename(filepath)
  return vim.fn.fnamemodify(filepath, ':t:r')
end

--- Get file extension
--- @param filepath string The file path
--- @return string The file extension (without dot)
function M.get_extension(filepath)
  return vim.fn.fnamemodify(filepath, ':e')
end

return M
