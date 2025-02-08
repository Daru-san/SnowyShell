use crate::sys::{
    cpu::cpu_usage::{core_count, cpu_core_usage, cpu_usage},
    mem::mem_usage::{memory_usage, swap_usage, total_memory, total_swap, used_memory, used_swap},
    net::net_stats::{get_ifaces, rx_bytes, tx_bytes},
};
use mlua::prelude::*;

#[mlua::lua_module]
fn sysinfo(lua: &Lua) -> LuaResult<LuaTable> {
    let mem_table = lua.create_table()?;
    mem_table.set("mem_usage", LuaFunction::wrap_raw::<_, ()>(memory_usage))?;
    mem_table.set("total_mem", LuaFunction::wrap_raw::<_, ()>(total_memory))?;
    mem_table.set("used_mem", LuaFunction::wrap_raw::<_, ()>(used_memory))?;
    mem_table.set("swap_usage", LuaFunction::wrap_raw::<_, ()>(swap_usage))?;
    mem_table.set("total_swap", LuaFunction::wrap_raw::<_, ()>(total_swap))?;
    mem_table.set("used_swap", LuaFunction::wrap_raw::<_, ()>(used_swap))?;

    let cpu_table = lua.create_table()?;
    cpu_table.set("cpu_usage", LuaFunction::wrap_raw::<_, ()>(cpu_usage))?;
    cpu_table.set("core_count", LuaFunction::wrap_raw::<_, ()>(core_count))?;
    cpu_table.set(
        "core_usage",
        LuaFunction::wrap_raw::<_, (i32,)>(cpu_core_usage),
    )?;

    let net_table = lua.create_table()?;
    net_table.set("ifaces", LuaFunction::wrap_raw::<_, ()>(get_ifaces))?;
    net_table.set("tx_bytes", LuaFunction::wrap_raw::<_, (String,)>(rx_bytes))?;
    net_table.set("rx_bytes", LuaFunction::wrap_raw::<_, (String,)>(tx_bytes))?;

    let exports = lua.create_table()?;
    exports.set("memory", mem_table)?;
    exports.set("cpu", cpu_table)?;
    exports.set("network", net_table)?;
    Ok(exports)
}
