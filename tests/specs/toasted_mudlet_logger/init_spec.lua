describe("toasted_mudlet_logger init.lua", function()
    local pkg = require("toasted_mudlet_logger")

    it("should return a table", function()
        assert.is_table(pkg)
    end)

    it("should have a Logger module", function()
        assert.is_table(pkg.Logger)
        assert.is_function(pkg.Logger.new)
        assert.is_function(pkg.Logger.debug)
    end)

    it("should have a FakeLogger module", function()
        assert.is_table(pkg.FakeLogger)
        assert.is_function(pkg.FakeLogger.new)
        assert.is_function(pkg.FakeLogger.debug)
    end)
end)
