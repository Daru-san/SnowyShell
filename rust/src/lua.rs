use crate::sys::{
    cpu::cpu_usage::{core_count, cpu_usage},
    mem::mem_usage::{memory_usage, swap_usage, total_memory, total_swap, used_memory, used_swap},
    net::net_stats::get_ifaces,
};
use mlua::prelude::*;

#[mlua::lua_module]
fn snowy_utils(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;
    exports.set("mem_usage", LuaFunction::wrap_raw::<_, ()>(memory_usage))?;
    exports.set("total_mem", LuaFunction::wrap_raw::<_, ()>(total_memory))?;
    exports.set("used_mem", LuaFunction::wrap_raw::<_, ()>(used_memory))?;
    exports.set("swap_usage", LuaFunction::wrap_raw::<_, ()>(swap_usage))?;
    exports.set("total_swap", LuaFunction::wrap_raw::<_, ()>(total_swap))?;
    exports.set("used_swap", LuaFunction::wrap_raw::<_, ()>(used_swap))?;
    exports.set("cpu_usage", LuaFunction::wrap_raw::<_, ()>(cpu_usage))?;
    exports.set("core_count", LuaFunction::wrap_raw::<_, ()>(core_count))?;
    exports.set("infaces", LuaFunction::wrap_raw::<_, ()>(get_ifaces))?;
    // exports.set("rx_bytes", LuaFunction::wrap_raw::<_, ()>(rx_bytes(iface)))?;
    Ok(exports)
}
