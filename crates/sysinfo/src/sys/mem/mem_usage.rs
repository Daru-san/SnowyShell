use sysinfo::{MemoryRefreshKind, RefreshKind, System};

pub fn total_memory() -> u64 {
    let mut sys = System::new_with_specifics(
        RefreshKind::nothing().with_memory(MemoryRefreshKind::nothing().with_ram()),
    );
    sys.refresh_memory();

    sys.total_memory()
}

pub fn used_memory() -> u64 {
    let mut sys = System::new_with_specifics(
        RefreshKind::nothing().with_memory(MemoryRefreshKind::nothing().with_ram()),
    );
    sys.refresh_memory();

    sys.used_memory()
}

pub fn memory_usage() -> f32 {
    let mut sys = System::new_with_specifics(
        RefreshKind::nothing().with_memory(MemoryRefreshKind::nothing().with_ram()),
    );
    sys.refresh_memory();

    let used = sys.used_memory() as f32;
    let total = sys.total_memory() as f32;

    used / total
}

pub fn total_swap() -> u64 {
    let mut sys = System::new_with_specifics(
        RefreshKind::nothing().with_memory(MemoryRefreshKind::nothing().with_ram()),
    );
    sys.refresh_memory();

    sys.total_swap()
}

pub fn used_swap() -> u64 {
    let mut sys = System::new();
    sys.refresh_memory();

    sys.used_swap()
}

pub fn swap_usage() -> f32 {
    let mut sys = System::new();

    sys.refresh_memory();

    let used = sys.used_swap() as f32;
    let total = sys.total_swap() as f32;

    used / total
}
