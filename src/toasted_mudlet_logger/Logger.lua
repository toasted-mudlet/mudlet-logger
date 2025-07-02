local inspect = require "inspect"

local LogLevel = {
    DEBUG = {
        level = 1,
        color = "<green>",
        prefix = "[DEBUG]"
    },
    INFO = {
        level = 2,
        color = "<blue>",
        prefix = "[INFO]"
    },
    WARN = {
        level = 3,
        color = "<yellow>",
        prefix = "[WARN]"
    },
    ERROR = {
        level = 4,
        color = "<red>",
        prefix = "[ERROR]"
    }
}

local globalLogLevel = LogLevel.DEBUG.level
local logToMain = false

local function log(self, level, first, ...)
    if level.level < globalLogLevel then
        return
    end

    local msg = ""
    local inspects = ""

    if type(first) == "string" then
        msg = first
    else
        inspects = inspect.inspect(first)
    end

    local tag = self.tag and self.tag ~= "" and ("[" .. self.tag .. "] ") or ""
    local line = tag .. msg
    local args = {...}

    for _, v in pairs(args) do
        if #inspects > 0 then
            inspects = inspects .. ","
        end
        inspects = inspects .. "\n" .. inspect.inspect(v)
    end

    debugc(line .. inspects)

    if logToMain then
        cecho(level.color .. level.prefix .. " " .. line .. inspects .. "<reset>\n")
    end

    if level.level == LogLevel.ERROR.level then
        printDebug("Error logged: " .. line, true)
    end
end

--- Logger class for leveled logging in Mudlet.
-- @type Logger
local Logger = {}
Logger.__index = Logger

--- Set the global log level.
-- @function Logger.setGlobalLogLevel
-- @tparam string level One of "DEBUG", "INFO", "WARN", "ERROR"
function Logger.setGlobalLogLevel(level)
    if LogLevel[level] then
        globalLogLevel = LogLevel[level].level
    else
        error("Invalid log level: " .. tostring(level))
    end
end

--- Get the current global log level as a string.
-- @function Logger.getGlobalLogLevel
-- @treturn string The current log level name
function Logger.getGlobalLogLevel()
    for k, v in pairs(LogLevel) do
        if v.level == globalLogLevel then
            return k
        end
    end
end

--- Set whether to also log to the main console.
-- @function Logger.setLogToMain
-- @tparam boolean value True to log to main console, false otherwise
function Logger.setLogToMain(value)
    logToMain = value
end

--- Get whether logging to the main console is enabled.
-- @function Logger.getLogToMain
-- @treturn boolean True if logging to main console is enabled
function Logger.getLogToMain()
    return logToMain
end

--- Constructs a new Logger instance.
-- @function Logger.new
-- @tparam[opt] string tag Optional tag for the logger (e.g. "MyModule")
-- @treturn Logger A new Logger instance
function Logger:new(tag)
    -- If no tag is provided, try to infer one from the file path
    if not tag then
        local function normalizePath(path)
            return path:gsub("\\", "/")
        end
        local sourcePath = normalizePath(debug.getinfo(2, "S").source:sub(2))
        tag = sourcePath:match("([^/]+)%.lua$") or nil
    end

    local instance = setmetatable({
        tag = tag
    }, self)

    return instance
end

--- Log a debug-level message.
-- @function Logger:debug
-- @param first The first message or value to log
-- @param ... Additional values to log
function Logger:debug(first, ...)
    log(self, LogLevel.DEBUG, first, ...)
end

--- Log an info-level message.
-- @function Logger:info
-- @param first The first message or value to log
-- @param ... Additional values to log
function Logger:info(first, ...)
    log(self, LogLevel.INFO, first, ...)
end

--- Log a warning-level message.
-- @function Logger:warn
-- @param first The first message or value to log
-- @param ... Additional values to log
function Logger:warn(first, ...)
    log(self, LogLevel.WARN, first, ...)
end

--- Log an error-level message.
-- @function Logger:error
-- @param first The first message or value to log
-- @param ... Additional values to log
function Logger:error(first, ...)
    log(self, LogLevel.ERROR, first, ...)
end

return Logger
