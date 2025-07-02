describe("LoggingClass logger baseline", function()
    local FakeLogger = require("toasted_mudlet_logger.FakeLogger")

    before_each(function()
        package.loaded["toasted_mudlet_logger.Logger"] = nil
        package.loaded["tests.test_modules.LoggingClass"] = nil
    end)

    after_each(function()
        package.loaded["toasted_mudlet_logger.Logger"] = nil
        package.loaded["tests.test_modules.LoggingClass"] = nil
    end)

    it("raises errors when using the real logger outside Mudlet", function()
        local LoggingClass = require("tests.test_modules.LoggingClass")

        local obj
        assert.has_error(function()
            obj = LoggingClass:new()
        end)
        assert.has_error(function()
            obj:doSomeWork()
        end)
    end)

    it("does not raise an error when using the FakeLogger", function()
        package.loaded["toasted_mudlet_logger.Logger"] = FakeLogger

        local LoggingClass = require("tests.test_modules.LoggingClass")

        local obj
        assert.has_no.errors(function()
            obj = LoggingClass:new()
        end)
        assert.has_no.errors(function()
            obj:doSomeWork()
        end)
    end)
end)

describe("LoggingClass with a FakeLogger", function()
    local LoggingClass

    before_each(function()
        package.loaded["toasted_mudlet_logger.Logger"] = require("toasted_mudlet_logger.FakeLogger")
        package.loaded["tests.test_modules.LoggingClass"] = nil
        LoggingClass = require("tests.test_modules.LoggingClass")
    end)

    after_each(function()
        package.loaded["toasted_mudlet_logger.Logger"] = nil
    end)

    it("does not raise an error when doSomeWork is called", function()
        local obj = LoggingClass:new()
        assert.has_no.errors(function()
            obj:doSomeWork()
        end)
    end)

    it("does not raise an error when doRiskyWork is called", function()
        local obj = LoggingClass:new()
        assert.has_no.errors(function()
            obj:doRiskyWork()
        end)
    end)
end)

describe("FakeLogger API", function()
    local FakeLogger

    before_each(function()
        FakeLogger = require("toasted_mudlet_logger.FakeLogger")
    end)

    it("can set and get the global log level without error", function()
        assert.has_no.errors(function()
            FakeLogger.setGlobalLogLevel("DEBUG")
            FakeLogger.setGlobalLogLevel("INFO")
            FakeLogger.setGlobalLogLevel("WARN")
            FakeLogger.setGlobalLogLevel("ERROR")
        end)
        assert.is_string(FakeLogger.getGlobalLogLevel())
    end)

    it("can set and get logToMain without error", function()
        assert.has_no.errors(function()
            FakeLogger.setLogToMain(true)
            FakeLogger.setLogToMain(false)
        end)
        assert.is_boolean(FakeLogger.getLogToMain())
    end)

    it("can construct a FakeLogger instance with or without a tag", function()
        assert.has_no.errors(function()
            local logger1 = FakeLogger:new()
            local logger2 = FakeLogger:new("SomeTag")
            assert.is_table(logger1)
            assert.is_table(logger2)
        end)
    end)

    it("instance log methods are callable and do not error", function()
        local logger = FakeLogger:new("TestTag")
        assert.has_no.errors(function()
            logger:debug("debug message")
            logger:info("info message")
            logger:warn("warn message")
            logger:error("error message")
        end)
    end)
end)
