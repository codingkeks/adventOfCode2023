use std::fs::File;
use std::io::Read;
mod day4;

fn main() {

    //     let puzzle = r###"Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    // Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    // Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    // Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    // Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    // Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"###;
    let puzzle = get_from_file("day4_puzzle.txt");
    
    day4::part2(puzzle);
}

fn get_from_file(file_name: &str) -> String {

    // Attempt to open the file
    let mut file = match File::open(file_name) {
        Ok(f) => f,
        Err(e) => {
            eprintln!("Error opening file {}: {}", file_name, e);
            std::process::exit(1);
        }
    };

    // Read the contents of the file into a String
    let mut file_contents = String::new();
    if let Err(e) = file.read_to_string(&mut file_contents) {
        eprintln!("Error reading file {}: {}", file_name, e);
        std::process::exit(1);
    }

    return file_contents;
}