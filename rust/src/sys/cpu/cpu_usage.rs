use sysinfo::{Cpu, CpuRefreshKind, RefreshKind, System};

pub fn cpu_usage() -> f32 {
    let mut sys = System::new_with_specifics(
        RefreshKind::new().with_cpu(CpuRefreshKind::new().with_cpu_usage()),
    );

    std::thread::sleep(sysinfo::MINIMUM_CPU_UPDATE_INTERVAL);

    sys.refresh_cpu_usage();

    sys.global_cpu_usage() / 100.0
}

pub fn cpu_core_usage(core_index: i32) -> f32 {
    use num_cpus;
    use sysinfo::{CpuRefreshKind, RefreshKind, System};
    let mut sys = System::new_with_specifics(
        RefreshKind::new().with_cpu(CpuRefreshKind::new().with_cpu_usage()),
    );

    std::thread::sleep(sysinfo::MINIMUM_CPU_UPDATE_INTERVAL);
    sys.refresh_cpu_usage();

    let core_count = num_cpus::get() as i32;
    let mut i: i32 = 0;
    let mut cpu_usage = -1.0;
    for cpu in sys.cpus() {
        i += 1;
        if i == core {
            cpu_usage = cpu.cpu_usage();
        }
        if i == core_count {
            break;
        }
    }
    cpu_usage
}

pub fn core_count() -> u32 {
    use num_cpus;
    
    num_cpus::get_physical().try_into().unwrap()
}
