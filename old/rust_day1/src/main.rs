use std::fs;
use std::env;

fn main() {
    	println!("Hello, world!");
	let filename = env::args().nth(1).expect("Please provide a filename");
	let input = fs::read_to_string(&filename).expect("Could not read file");
	// let s = String::from("1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet");
	let lines: Vec<&str> = input.split('\n').collect();
	println!("total lines: {}", lines.len());

	let mut combined = 0;
	for line in lines {
		let first_number = line.chars().filter(|c| c.is_numeric()).next();
		let last_number = line.chars().rev().filter(|c| c.is_numeric()).next();
				
    		match (first_number, last_number) {
        		(Some(first_number), Some(last_number)) => {
				let result = format!("{}{}", first_number, last_number);
				let result_int: u32 = result.parse().expect("Failed to convert to integer"); 
				println!("{} --> {}, {} = {}", line, first_number.to_digit(10).unwrap(), last_number.to_digit(10).unwrap(), result_int);
				combined = combined + result_int;	
			},
			_ => println!("No number found in the string or not both start and end.")
    		}
	}
	println!("sum of all calibration values: {}", combined);
}
