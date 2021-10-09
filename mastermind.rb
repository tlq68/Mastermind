require 'colorize'

module Maker
    def code_maker(range, length)
        code_array = Array.new(generate_code(range, length))
    end

    def generate_code(range, length)
        code = []
        (length).times do 
            number = random_number(range)
            code.push(number.to_s)
        end
        code
    end

    private

    def random_number(number)
        rand(number) + 1
    end 
end

module Breaker
    @@round_counter = 0
    @@exact_matches = 0
    @@correct_choices = 0
    def play
        @@round_counter = 0
        @@exact_matches = 0
        @@correct_choices = 0
        input = ''
        game_code = code_maker(6,4)
        
        while input != 'q' do
            @@round_counter += 1
            puts "Put in a code."
            input = input_checker(game_code.length)
            input_guess = input.split('')
            if input == 'q'
                quit
                break
            end

            code_breaker_exact(game_code, input_guess)
            check_if_present(game_code, input_guess)
            puts "\nYou have" + " #{@@exact_matches} ".light_yellow + "exact match#{singlular_vs_plural_es(@@exact_matches)}!"
            puts "You have" + " #{@@correct_choices} ".yellow + "correct choice#{singlular_vs_plural_s(@@correct_choices)}.\n"
            
            if @@exact_matches == game_code.length
                win
                play_again
                break
            end
        end
    end

    private

    def code_breaker_exact(secret_code, guess)
        @@exact_matches = 0
        (secret_code.length).times do |element|
            if secret_code[element] == guess[element]
                @@exact_matches += 1
            end
        end
    end

    def check_if_present(array_of_choices, user_input)
        @@correct_choices = 0
        array_of_choices.each do |element|
            choice_eliminated(user_input, element)
        end
    end

    def choice_eliminated(array_of_choices, choice)
        new_arr = array_of_choices
        
        if array_of_choices.include?(choice)
          new_arr.slice!(array_of_choices.find_index(choice), 1)
          @@correct_choices += 1
        end
    end

    def win
        puts "\nYou won in" + " #{@@round_counter} round#{singlular_vs_plural_s(@@round_counter)}! ".light_yellow + "Congratulations!"
        @@round_counter = 0
    end

    def singlular_vs_plural_s(number)
        return 's' if number != 1
    end

    def singlular_vs_plural_es(number)
        return 'es' if number != 1
    end

    def input_checker(length)
        input = ''
        correct_input = (/^[1-9]{#{length}}$/)

        while !(input.match(correct_input)) 
            
            input = gets.chomp.downcase
            break if input == 'q' || input.match(correct_input)
            puts "Please enter a number (1-9) with #{length} digits."
        end
        input
    end

    def quit
        puts "Thanks for playing!"
        exit
    end

    def play_again
        while true
            puts "\nDo you want to play again? (" + "Y".light_green + "/" + "N".yellow + ")"
            input = gets.chomp.downcase

            case(input)
            when 'y'
                game = PlayGame.new
                game.play
            when 'n'
                quit
            end
            quit if input == 'q'
        end
    end
end

class Computer 
    @@round_counter = 0
    @@exact_matches = 0
    @@correct_choices = 0
    
    include Maker
    include Breaker

    def play
        @@round_counter = 0
        @@exact_matches = 0
        @@correct_choices = 0

        loop do
            puts "\nSet the code that the computer will solve!"
            set_code = gets.chomp.downcase
            quit if set_code == 'q'

            if set_code.match((/^[1-9]{4}$/))
                user_input = set_code.split('')
                p user_input
                computer_guess = [random_number(6).to_s, random_number(6).to_s, random_number(6).to_s, random_number(6).to_s]    
                keep_matches(user_input, computer_guess)
                play_again
            else
                puts "\nEnter a 4 digit number (1-9).".light_yellow, "Example: 1234".light_red
            end
        end
        exit
    end

    protected

    def keep_matches(input_array, guess_array)
        new_arr = guess_array
        while input_array != guess_array
            new_round(input_array, guess_array)
            puts "\nPress 'ENTER' for next guess."
            next_guess = gets.chomp.downcase
            quit if next_guess == 'q'

            input_array.each_with_index do |element, index|
                if guess_array[index] != input_array[index]
                    guess_array[index] = random_number(6).to_s
                end
        
                if @@round_counter == 100 
                    puts "Wow. 100 rounds? Really?"
                    break
                end
            end
        end
        new_round(input_array, guess_array)
        puts "\nIt took the computer" + " #{@@round_counter} round#{singlular_vs_plural_s(@@round_counter)} ".light_yellow + "to guess your code."
    end

    def new_round(input, guess)
        @@round_counter += 1
        puts "\nRound #{@@round_counter}".light_yellow
        puts "\nYou made the secret code.", "#{input}".light_blue
        puts "The computer has guessed:", "#{guess}".green  
    end
end

class Player 
    @@round_counter = 0
    @@exact_matches = 0
    @@correct_choices = 0

    include Maker
    include Breaker
end

class PlayGame
    @@round_counter = 0
    @@exact_matches = 0
    @@correct_choices = 0

    def play
        computer = Computer.new
        player = Player.new

        @@round_counter = 0
        @@exact_matches = 0
        @@correct_choices = 0

        introduction()

        while true
            puts "\nEnter '1' to be the code" + " MAKER.".light_blue
            puts "Enter '2' to be the code" + " BREAKER.".green
            puts "Enter 'q' to exit."
            option = gets.chomp.downcase                
        
            case(option)
            when "1"
                mode(player, computer)
            when "2"
                mode(computer, player)
            when "q"
                exit
            else
                puts "\nPlease enter a valid option."
            end
        end 
    end

    def introduction
        puts "\nWelcome to mastermind. You can either be the code maker or the code breaker.".light_yellow
        puts "\nExample:"
        puts "\nThe" + " MAKER ".light_blue+ "creates the code:" + " [\"2\", \"3\", \"4\", \"4\"]".light_blue
        puts "And the" + " BREAKER ".green + "guesses:" + " [\"1\", \"2\", \"3\", \"4\"]".green
        puts "\nThe" + " BREAKER ".green + "will receive the following hint:"
        puts "You have" + " 1 ".light_yellow + "exact match!"
        puts "You have" + " 3 ".yellow + "correct choices."
        puts "\nBecause the" + " BREAKER ".green + "correctly chose 3 numbers and has", "1 number in the correct position."
    end

    def mode(maker, breaker)
        maker.generate_code(6,4)
        breaker.play
    end
end

game = PlayGame.new
game.play
