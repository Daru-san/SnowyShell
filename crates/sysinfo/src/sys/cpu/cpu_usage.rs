use sysinfo::{Cpu, CpuRefreshKind, RefreshKind, System};

pub fn cpu_usage() -> f32 {
    let mut sys = System::new_with_specifics(
        RefreshKind::nothing().with_cpu(CpuRefreshKind::nothing().with_cpu_usage()),
    );

    std::thread::sleep(sysinfo::MINIMUM_CPU_UPDATE_INTERVAL);

    sys.refresh_cpu_usage();

    sys.global_cpu_usage() / 100.0
}

pub fn cpu_core_usage(core_index: i32) -> f32 {
    use num_cpus;

    let mut sys = System::new_with_specifics(
        RefreshKind::nothing().with_cpu(CpuRefreshKind::nothing().with_cpu_usage()),
    );

    std::thread::sleep(sysinfo::MINIMUM_CPU_UPDATE_INTERVAL);

    sys.refresh_cpu_usage();

    let core_count = num_cpus::get() as i32;

    assert!(core_index <= core_count && core_index >= 0);

    let cpu_core: &Cpu = &sys.cpus()[core_index as usize];

    cpu_core.cpu_usage()
}

pub fn core_count() -> u32 {
    use num_cpus;

    num_cpus::get_physical().try_into().unwrap()
}
