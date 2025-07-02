# Toasted Mudlet Logger

A LuaRocks-packaged logging library for [Mudlet](https://www.mudlet.org/).  
Provides leveled logging for Mudlet packages.

Mudlet is a free, open-source, cross-platform client for playing and scripting
MUDs (Multi-User Dungeons).

## Requirements

- [Lua 5.1](https://www.lua.org/versions.html#5.1) — Mudlet embeds Lua 5.1
- [Mudlet](https://www.mudlet.org/) — depends on the Mudlet runtime environment
- An **integration layer** that integrates LuaRocks dependencies into your Mudlet
  package, allowing you to use external Lua modules managed by LuaRocks.  
  See [mudlet-muddler-luarocks-starter](https://github.com/toasted-mudlet/mudlet-muddler-luarocks-starter) for a ready-to-use template and
  details on integrating LuaRocks modules with Mudlet packages

## Mudlet environment dependencies

This logger is designed for use in **Mudlet packages**. It depends on several
Mudlet-specific APIs and global functions, and does not work in a generic Lua
environment.

**Required Mudlet APIs and globals:**

- `debugc`  
  Used to print log messages to the Mudlet debug console
- `cecho`  
  Used to print colored log messages to the main Mudlet console
- `printDebug`  
  Used to print stacktraces for error-level logs
- `getMudletHomeDir`  
  Used to determine the Mudlet home directory for dynamic scope tagging

> **Note:**  
> Usage outside your package code, such as in global scripts or the Mudlet
> editor, is discouraged and, in any case, depends on your LuaRocks integration
> layer.

## Installation

```
luarocks install toasted_mudlet_logger
```

Or, if using a custom tree:

```
luarocks install --tree=lua_modules toasted_mudlet_logger
```

Then build your Mudlet package as usual.

## Usage

After installing, require the logger in your Mudlet package code:

```
local logger = require("toasted_mudlet_logger")

logger.info("Logger initialized!")
logger.warn("This is a warning message.")
logger.error("This is an error message.")
logger.debug("Debugging details here.")
```

### Setting the global log level

You can control which log messages are shown by setting the global log level.  
Valid levels are `"DEBUG"`, `"INFO"`, `"WARN"`, and `"ERROR"` (case-sensitive):

```
logger.setGlobalLogLevel("INFO")
```

This will suppress all `DEBUG` messages and show only `INFO`, `WARN`,
and `ERROR` messages.

### Logging to the main console

By default, logs are sent to the Mudlet error console.  
To also log to the main game console, enable this with:

```
logger.setLogToMain(true)
```

You can turn this off again with:

```
logger.setLogToMain(false)
```

### Using the FakeLogger for testing outside Mudlet

If you run tests outside the Mudlet runtime (for example,
in CI or a generic Lua environment), you can replace the real logger with the
provided `FakeLogger`. The `FakeLogger` implements the same interface as the
real logger but does nothing, preventing errors caused by missing Mudlet
functions.

**Example (in your test setup):**

```
-- Override the logger module before requiring your code under test
package.loaded["toasted_mudlet_logger.Logger"] = require("toasted_mudlet_logger.FakeLogger")
local myModule = require("my_module_that_uses_logger")

-- Now, calling logger methods will not fail outside Mudlet
myModule.doSomethingThatLogs()
```

This approach is useful for running automated tests or scripts in environments
where Mudlet"s APIs are not available.

## Attribution

If you create a new project based substantially on this logger, please consider
adding the following attribution or similar for all derived code:

> This project is based on [Toasted Mudlet Logger](https://github.com/toasted-mudlet/mudlet-logger), originally
> licensed under the MIT License (see [LICENSE](LICENSE) for details). All
> original code and documentation remain under the MIT License.

## License

Copyright © 2025 github.com/toasted323

This project is licensed under the MIT License.  
See [LICENSE](LICENSE) in the root of this repository for full details.
