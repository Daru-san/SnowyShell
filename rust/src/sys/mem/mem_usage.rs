use sysinfo::System;

pub fn total_memory() -> i32 {
    let mut sys = System::new();
    sys.refresh_memory();

    sys.total_memory().try_into().unwrap()
}

pub fn used_memory() -> i32 {
    let mut sys = System::new();
    sys.refresh_memory();

    sys.used_memory().try_into().unwrap()
}

pub fn memory_usage() -> f32 {
    let mut sys = System::new();
    sys.refresh_memory();

    let used = sys.used_memory() as f32;
    let total = sys.total_memory() as f32;

    used / total
}

pub fn total_swap() -> i32 {
    let mut sys = System::new();
    sys.refresh_memory();

    sys.total_swap().try_into().unwrap()
}

pub fn used_swap() -> i32 {
    let mut sys = System::new();
    sys.refresh_memory();

    sys.used_swap().try_into().unwrap()
}

pub fn swap_usage() -> f32 {
    let mut sys = System::new();

    sys.refresh_memory();

    let used = sys.used_swap() as f32;
    let total = sys.total_swap() as f32;

    used / total
}
