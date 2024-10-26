use std::{thread::sleep, time::Duration};
use sysinfo::System;

pub fn print_decimal() {
    let mut sys = System::new();

    loop {
        sys.refresh_memory();
        let usage = sys.used_memory();
        let total = sys.total_memory();
        let value = (usage as f64) / (total as f64);
        print!("\r{:.02}", value);
        sleep(Duration::from_millis(10));
    }
}

pub fn print_percent() {
    let mut sys = System::new();

    loop {
        sys.refresh_memory();
        let usage = sys.used_memory();
        let total = sys.total_memory();
        let value = (usage as f64) / (total as f64);
        print!("\r{:.02}%", value * 100.0);
        sleep(Duration::from_millis(10));
    }
}


