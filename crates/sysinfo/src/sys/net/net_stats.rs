use std::{thread::sleep, time::Duration};

use sysinfo::Networks;

pub fn tx_bytes(iface: impl Into<String>) -> u64 {
    let interface = iface.into();

    assert!(get_ifaces().contains(&interface));

    let mut networks = Networks::new_with_refreshed_list();

    let mut tx_bytes = 0;

    sleep(Duration::from_millis(10));

    networks.refresh(true);

    for (interface_name, network) in &networks {
        if interface_name == &interface {
            tx_bytes = network.transmitted();
        }
    }

    tx_bytes
}

pub fn rx_bytes(iface: impl Into<String>) -> u64 {
    let interface = iface.into();

    assert!(get_ifaces().contains(&interface));

    let mut networks = Networks::new_with_refreshed_list();

    let mut rx_bytes = 0;

    sleep(Duration::from_millis(10));

    networks.refresh(true);

    for (interface_name, network) in &networks {
        if interface_name == &interface {
            rx_bytes = network.received();
        }
    }

    rx_bytes
}

pub fn get_ifaces() -> String {
    let networks = Networks::new_with_refreshed_list();

    let mut ifaces = String::new();

    for (interface_name, _network) in &networks {
        ifaces.push_str(interface_name);
    }

    ifaces
}
