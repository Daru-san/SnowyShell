rockspec_format = "3.0"
package = "idle-inhibitor"
version = "dev-1"

source = {
  url = "git+https://github.com/Daru-san/SnowyShell",
  tag = "0.1.0",
}

description = {
  summary = "Lua module used in SnowyShell",
  detailed = "...",
  homepage = "https://github.com/Daru-san/SnowyShell",
  license = "MIT",
}

dependencies = {
  "lua >= 5.1",
  "luarocks-build-rust-mlua",
}

build = {
  type = "rust-mlua",

  modules = {
    "idle-inhibitor",
  },
}
