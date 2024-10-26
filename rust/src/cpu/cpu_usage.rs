use std::{thread::sleep, time::Duration};
use sysinfo::System;

pub fn print_decimal() {
    let mut sys = System::new();

    loop {
        sys.refresh_cpu_usage();
        let usage = sys.global_cpu_usage();
        print!("\r{:.02}", usage / 100.0);
        sleep(Duration::from_millis(10));
    }
}

pub fn print_percent() {
    let mut sys = System::new();

    loop {
        sys.refresh_cpu_usage();
        let usage = sys.global_cpu_usage();
        print!("\r{:.02}%", usage);
        sleep(Duration::from_millis(10));
    }
}
