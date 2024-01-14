fn get_id(line: &str) -> usize {
    let id: usize = match line.split(':').next() {
        Some(card_id_str) => card_id_str.trim().parse().unwrap_or_else(|_| {
            eprintln!("Failed to parse card ID.");
            std::process::exit(1);
        }),
        None => {
            eprintln!("Invalid input format.");
            std::process::exit(1);
        }
    };
    return id;
}

fn get_numbers(line: &str, skip_first: bool) -> Vec<usize> {
    let winning_numbers: Vec<usize> = line
        .trim()
        .split_whitespace()
        .skip(if skip_first { 1 }  else { 0 }) // Skip the first element after splitting by whitespace
        .map(|num_str| {
            num_str.parse().unwrap_or_else(|_| {
                eprintln!("Failed to parse winning number.");
                std::process::exit(1);
            })
        })
        .collect();
    return winning_numbers;
}
// MARK: - Puzzle 1

pub fn part1(puzzle: String) {
    let mut total_points = 0;
    for card in puzzle.lines() {
        // Remove "Card " from the string
        let without_card_prefix = card.trim_start_matches("Card "); // 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19

        let parts: Vec<&str> = without_card_prefix.split('|').collect();

        let id: usize = get_id(parts[0]);
        let winning_numbers: Vec<usize> = get_numbers(parts[0], true);
        let set_numbers: Vec<usize> = get_numbers(parts[1], false);

        print!("ID: {} | ", id);
        print!("WN: {:?} | ", winning_numbers);
        print!("SN: {:?}", set_numbers);

        // Iterate over set
        let mut amount_numbers_won = 0;
        for &number in &set_numbers {
            if winning_numbers.contains(&number) {
                amount_numbers_won += 1;
            }
        }

        // print!("count numbers won: {}", amount_numbers_won);
        let mut points = 0;
        if amount_numbers_won > 0 {
            points = i32::pow(2, amount_numbers_won - 1);
        }
        print!(" points -> {}", points);
        println!("");
        total_points += points;
    }

    println!("Total points: {}", total_points);
}

pub fn part2(puzzle: String) {
    let mut total_points = 0;
    for card in puzzle.lines() {
        // Remove "Card " from the string
        let without_card_prefix = card.trim_start_matches("Card "); // 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19

        let parts: Vec<&str> = without_card_prefix.split('|').collect();

        let id: usize = get_id(parts[0]);
        let winning_numbers: Vec<usize> = get_numbers(parts[0], true);
        let set_numbers: Vec<usize> = get_numbers(parts[1], false);

        print!("ID: {} | ", id);
        print!("WN: {:?} | ", winning_numbers);
        print!("SN: {:?}", set_numbers);

        let mut amount_numbers_won = 0;
        for &number in &set_numbers {
            if winning_numbers.contains(&number) {
                amount_numbers_won += 1;
            }
        }

        // print!("count numbers won: {}", amount_numbers_won);
        let mut points = 0;
        if amount_numbers_won > 0 {
            points = i32::pow(2, amount_numbers_won - 1);
        }
        print!(" points -> {}", points);
        println!("");
        total_points += points;
    }

    println!("Total points: {}", total_points);
}
