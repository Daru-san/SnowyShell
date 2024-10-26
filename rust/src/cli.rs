use crate::{cpu::cpu_usage, mem::mem_usage, net::net_stats};
use clap::{Parser, Subcommand};
use std::process::exit;

#[derive(Parser, Debug)]
#[command(author, version, about)]
struct Args {
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand, Debug)]
enum Commands {
    /// Cpu usage
    Cpu {
        /// Show value as percentage
        #[clap(short, long)]
        percent: bool,

        /// Show value in decimal form
        #[clap(short, long)]
        decimal: bool,
    },

    /// Memory usage
    Mem {
        /// Show value as percentage
        #[clap(short, long)]
        percent: bool,

        /// Show value as decial
        #[clap(short, long)]
        decimal: bool,
    },

    /// Network stats
    Net {
        /// List interfaces
        #[clap(short, long)]
        list_interfaces: bool,

        /// Show transfer speeds
        #[clap(short, long)]
        tx: bool,

        /// Show write speeds
        #[clap(short, long)]
        rx: bool,

        /// Specific interface to pick
        #[clap(short, long, default_value = "wlan0")]
        inteface: String,
    },
}

pub fn run_cli() {
    let args = Args::parse();

    match &args.command {
        Some(Commands::Cpu { percent, decimal }) => {
            let as_percent: bool = *percent;
            let as_decimal: bool = *decimal;
            if as_percent && as_decimal {
                println!("Please select one of percent or decimal!");
                exit(0);
            }
            if as_percent {
                cpu_usage::print_percent();
            }
            if as_decimal {
                cpu_usage::print_decimal()
            }
        }
        Some(Commands::Mem { percent, decimal }) => {
            let as_percent: bool = *percent;
            let as_decimal: bool = *decimal;
            if as_percent && as_decimal {
                println!("Please select one of percent or decimal!");
                exit(0);
            }
            if as_decimal {
                mem_usage::print_decimal();
            }
            if as_percent {
                mem_usage::print_percent();
            }
        }
        Some(Commands::Net {
            tx,
            rx,
            list_interfaces,
            inteface,
        }) => {
            let show_tx = *tx;
            let show_rx = *rx;

            if *list_interfaces {
                net_stats::print_ifaces();
            } else {
                let iface = inteface;

                if iface.is_empty() {
                    println!("Please select an interface");
                    exit(0);
                }

                if show_tx && show_rx {
                    println!("Please choose one of read or write");
                    exit(0);
                }

                if show_tx {
                    net_stats::print_tx(iface.to_string());
                }

                if show_rx {
                    net_stats::print_rx(iface.to_string());
                }
            }
        }
        None => {
            println!("There was no subcommand given");
        }
    }
}
