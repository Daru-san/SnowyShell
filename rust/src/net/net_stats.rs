use std::{process::exit, thread::sleep, time::Duration};

use sysinfo::Networks;

pub fn print_tx(iface: String) {
    let mut networks = Networks::new_with_refreshed_list();

    let mut iface_found: bool = false;

    sleep(Duration::from_millis(10));

    networks.refresh();

    for (interface_name, network) in &networks {
        if interface_name == &iface {
            println!("{} B", network.transmitted());
            iface_found = true;
        }
    }

    if !iface_found {
        println!("Interface {} was not found", iface);
        exit(0)
    }
}

pub fn print_rx(iface: String) {
    let mut networks = Networks::new_with_refreshed_list();

    let mut iface_found: bool = false;

    sleep(Duration::from_millis(0));

    networks.refresh();

    for (interface_name, network) in &networks {
        if interface_name == &iface {
            println!("{} B", network.received());
            iface_found = true;
        }
    }

    if !iface_found {
        println!("Interface {} was not found", iface);
    }
}

pub fn print_ifaces() {
    let networks = Networks::new_with_refreshed_list();
    println!("Available interfaces:");
    for (interface_name, _network) in &networks {
        println!("{}", interface_name.to_string());
    }
}
