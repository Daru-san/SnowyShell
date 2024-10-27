use std::{borrow::Borrow, process::exit, thread::sleep, time::Duration};

use sysinfo::Networks;

fn _find_iface(iface: &str, networks: &Networks) -> String {
    let mut iface_name = String::new();
    for (interface_name, _network) in networks {
        if interface_name == iface {
            iface_name = interface_name.to_string();
            break;
        } else {
            _print_iface_error(iface.to_string());
        }
    }
    iface_name
}

fn _print_iface_error(iface: String) {
    println!("Interface {} was not found", iface);
    exit(0)
}

pub fn tx_bytes(iface: impl Into<String>) -> u64 {
    let mut networks = Networks::new_with_refreshed_list();

    let interface = _find_iface(&iface.into(), networks.borrow());

    let mut tx_bytes = 0;

    sleep(Duration::from_millis(10));

    networks.refresh();

    for (interface_name, network) in &networks {
        if interface_name == &interface {
            tx_bytes = network.transmitted();
        }
    }

    tx_bytes
}

pub fn rx_bytes(iface: impl Into<String>) -> u64 {
    let mut networks = Networks::new_with_refreshed_list();

    let interface = _find_iface(&iface.into(), networks.borrow());

    let mut rx_bytes = 0;

    sleep(Duration::from_millis(10));

    networks.refresh();

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
