local Logger = require("toasted_mudlet_logger.Logger")

describe("Logger", function()

    local logger
    local debugc_output = {}
    local cecho_output = {}

    before_each(function()
        _G.debugc = function(message)
            table.insert(debugc_output, message)
        end

        _G.printDebug = function(message, includeStackTrace)
            table.insert(debugc_output, "PrintDebug: " .. message .. (includeStackTrace and " (with stack trace)" or ""))
        end

        _G.cecho = function(message)
            table.insert(cecho_output, message)
        end

        _G.getMudletHomeDir = function()
            return "/mock/mudlet/home"
        end

        debugc_output = {}
        cecho_output = {}

        logger = Logger:new("TestModule")
        Logger.setLogToMain(true)
        Logger.setGlobalLogLevel("DEBUG")
    end)

    it("should create a logger instance", function()
        assert.is.table(logger)
    end)

    it("should log debug messages correctly", function()
        logger:debug("This is a debug message")
        assert.equals("[TestModule] This is a debug message", debugc_output[1])
        assert.equals("<green>[DEBUG] [TestModule] This is a debug message<reset>\n", cecho_output[1])
    end)

    it("should log info messages correctly", function()
        logger:info("This is an info message")
        assert.equals("[TestModule] This is an info message", debugc_output[1])
        assert.equals("<blue>[INFO] [TestModule] This is an info message<reset>\n", cecho_output[1])
    end)

    it("should log warning messages correctly", function()
        logger:warn("This is a warning message")
        assert.equals("[TestModule] This is a warning message", debugc_output[1])
        assert.equals("<yellow>[WARN] [TestModule] This is a warning message<reset>\n", cecho_output[1])
    end)

    it("should log error messages correctly", function()
        logger:error("This is an error message")
        assert.equals("[TestModule] This is an error message", debugc_output[1])
        assert.equals("<red>[ERROR] [TestModule] This is an error message<reset>\n", cecho_output[1])
        assert.equals("PrintDebug: Error logged: [TestModule] This is an error message (with stack trace)",
            debugc_output[2])
    end)

    it("should respect global log level settings", function()
        Logger.setGlobalLogLevel("WARN")

        debugc_output = {}
        cecho_output = {}

        logger:debug("This debug message should not appear")
        logger:info("This info message should not appear")

        assert.is.equal(0, #debugc_output)
        assert.is.equal(0, #cecho_output)

        logger:warn("This warning should appear")

        assert.is.equal(1, #debugc_output)
        assert.is.equal(1, #cecho_output)

        logger:error("Error occurred")

        assert.is.equal(3, #debugc_output)
        assert.is.equal(2, #cecho_output)
    end)

    it("should not log info messages when global level is WARN", function()
        Logger.setGlobalLogLevel("WARN")

        local logger2 = Logger:new("AnotherModule")

        logger2:info("This info should not appear due to global log level")

        assert.is.equal(0, #debugc_output)
        assert.is.equal(0, #cecho_output)
    end)

end)
