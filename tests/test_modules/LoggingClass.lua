local Logger = require("toasted_mudlet_logger.Logger")

local LoggingClass = {}
LoggingClass.__index = LoggingClass

function LoggingClass.new()
    local self = setmetatable({}, LoggingClass)
    self.logger = Logger:new("LoggingClass")

    self.logger:debug("LoggingClass created")
    return self
end

function LoggingClass:doSomeWork()
    self.logger:info("Some work started")
    -- ...do some work...
    self.logger:info("Some work finished")
end

function LoggingClass:doRiskyWork()
    self.logger:warn("Risky operation attempted")
    self.logger:error("Risky operation failed")
end

return LoggingClass
