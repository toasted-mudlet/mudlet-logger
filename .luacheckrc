std = "lua51"
color = true
codes = true

globals = { "debugc", "cecho", "printDebug" }

ignore = {
    "631", -- ignore 'line is too long'
}

exclude_files = {
    "lua",
    "luarocks",
    ".luarocks/",
    "lua_modules/"
}

files = {
    ["src/toasted_mudlet_logger/FakeLogger.lua"] = {
        ignore = {
            "212",   -- ignore 'unused argument'
        }
    }
}

files["tests/**/*_spec.lua"].ignore = {
    "212",   -- ignore 'unused argument'
}