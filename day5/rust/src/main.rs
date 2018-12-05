extern crate rayon;

use std::fs::File;
use std::io::prelude::*;
use rayon::prelude::*;

fn reduce(mut data: Vec<u8>, mut out: Vec<u8>) -> Vec<u8> {
    let mut change = true;
    while change {
        change = false;
        out.clear();
        {
            let mut it = data.iter().peekable();
            while let Some(b) = it.next() {
                let discard = {
                    if let Some(n) = it.peek() {
                        if (*b as i32 - **n as i32).abs() == 32 {
                            true
                        } else {
                            false
                        }
                    } else {
                        false
                    }
                };
                if discard {
                    it.next();
                    change = true;
                } else {
                    out.push(*b);
                }
            }
        }
        if change {
            let tmp = out;
            out = data;
            data = tmp;
        }
    }
    out
}

fn main() {
    let mut inpf = File::open("../input").expect("File is missing");
    let mut data = Vec::new();
    inpf.read_to_end(&mut data).expect("Error reading");

    let out: Vec<u8> = Vec::with_capacity(data.len()); // a bit overkill, but meh
    let out = reduce(data.clone(), out);
    println!("Part 1: {}", out.len());
    let results: Vec<_> = (65u8 .. 91u8).into_par_iter().map(|ch| {
        let fd: Vec<u8> = data.iter().cloned().filter(|cc| *cc != ch && *cc != ch + 32).collect();
        let len = fd.len();
        let out = reduce(fd, Vec::with_capacity(len));
        (ch, out.len())
    }).collect();
    for (ch, count) in results.iter() {
        println!("{}: {}", String::from_utf8_lossy(&[*ch]), count);
    }
}
