extern crate rayon;

use rayon::prelude::*;
use std::fs::File;
use std::io::prelude::*;

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

fn reduce_fast(data: &Vec<u8>) -> usize {
    let mut buff = Vec::with_capacity(data.len() / 5);
    buff.push(data[0]);
    for ch in data.iter().skip(1) {
        if buff.len() > 0 && (*ch as i32 - buff[buff.len() - 1] as i32).abs() == 32 {
            buff.pop();
        } else {
            buff.push(*ch);
        }
    }
    buff.len()
}

fn main() {
    let mut inpf = File::open("input").expect("File is missing");
    let mut data = Vec::new();
    inpf.read_to_end(&mut data).expect("Error reading");

    let out = reduce_fast(&data);
    println!("Part 1: {}", out);
    let results: Vec<_> = (65u8..91u8)
        .into_par_iter()
        .map(|ch| {
            let fd: Vec<u8> = data
                .iter()
                .cloned()
                .filter(|cc| *cc != ch && *cc != ch + 32)
                .collect();
            let out = reduce_fast(&fd);
            (ch, out)
        }).collect();
    for (ch, count) in results.iter() {
        println!("{}: {}", String::from_utf8_lossy(&[*ch]), count);
    }
}
