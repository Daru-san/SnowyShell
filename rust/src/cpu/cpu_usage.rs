use sysinfo::{CpuRefreshKind, RefreshKind, System};

pub fn print_decimal() {
    let mut sys =
        System::new_with_specifics(RefreshKind::new().with_cpu(CpuRefreshKind::everything()));

    std::thread::sleep(sysinfo::MINIMUM_CPU_UPDATE_INTERVAL);

    sys.refresh_cpu_usage();
    print!("{:.02}", sys.global_cpu_usage() / 100.0);
}

pub fn print_percent() {
    let mut sys =
        System::new_with_specifics(RefreshKind::new().with_cpu(CpuRefreshKind::everything()));

    std::thread::sleep(sysinfo::MINIMUM_CPU_UPDATE_INTERVAL);
    sys.refresh_cpu_usage();
    println!("{:.02}%", sys.global_cpu_usage());
}
