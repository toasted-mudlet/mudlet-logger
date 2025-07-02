local FakeLogger = {}
FakeLogger.__index = FakeLogger

function FakeLogger.setGlobalLogLevel(level)
end

function FakeLogger.getGlobalLogLevel()
    return "DEBUG"
end

function FakeLogger.setLogToMain(value)
end

function FakeLogger.getLogToMain()
    return false
end

function FakeLogger:new(tag)
    return setmetatable({
        tag = tag or nil
    }, self)
end

function FakeLogger:debug(...)
end
function FakeLogger:info(...)
end
function FakeLogger:warn(...)
end
function FakeLogger:error(...)
end

return FakeLogger
