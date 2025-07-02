package = "toasted_mudlet_logger"
version = "dev-1"

source = {
    url = "git+https://github.com/toasted-mudlet/mudlet-logger.git",
    tag = "dev-1"
}

description = {
    summary = "A leveled logging library for Mudlet.",
    detailed = [[
        Leveled logging for Mudlet package development.
    ]],
    homepage = "https://github.com/toasted-mudlet/mudlet-logger",
    license = "MIT"
}

dependencies = {
    "inspect >= 3.1.3-0",
    "lua >= 5.1, < 5.2"
}

build = {
    type = "builtin",
    modules = {
        ["toasted_mudlet_logger"] = "src/toasted_mudlet_logger/init.lua",
        ["toasted_mudlet_logger.Logger"] = "src/toasted_mudlet_logger/Logger.lua",
        ["toasted_mudlet_logger.FakeLogger"] = "src/toasted_mudlet_logger/FakeLogger.lua"
    }
}
