require 'colorize'

# Welcome to mastermind. You can either be the code maker or the code breaker.

##
## Game class: First, work with the computer selecting the numbers and storing the result in an array. The player will be able to input 4 digits and these two arrays will be compared. When checking the spots, we will need two loops? One to check if the number is correct and the other loop to check if the number is also in the correct position. 
##

## 1. Make computer that selects 4 random numbers (1-6).
## 2. 

# The code maker will enter 4 numbers (1-6), which each represent a color. There can be repeats. 

# The code breaker will need to crack the code within 12 turns by identifying both the correct colors and positions. 

# If the code breaker identifies a color in the correct position, they will receive this hint (HINT). If the code breaker identifies a color that is not in the correct position, they will receive this hint (HINT2).

# Example: 


# Enter 1 to be the code maker.
# Enter 2 to be the code breaker.

class Game
    @@round_counter = 0
    @@exact_matches = 0
    @@correct_choices = 0

    def self.code_maker(range, length)
        code_array = Array.new(Game.generate_code(range, length))
    end

    

    def self.random_number(number)
        rand(number) + 1
    end

    def self.generate_code(range, length)
        code = []
        (length).times do 
            number = self.random_number(range)
            code.push(number.to_s)
        end
        code
    end

    def self.play
       
        input = ''

        # Eventually allow user to choose length and complexity
        game_code = self.code_maker(6,4)
        tester = self.new

        p game_code
        while input != 'q' do
            @@round_counter += 1
            puts "Put in a code."
            input = self.input_checker(game_code.length)

            if input == 'q'
                quit
                break
            end

             self.code_breaker_exact(game_code, input.split(''))
             self.check_if_present(game_code, input.split(''))
             puts "\nYou have #{@@exact_matches} exact match#{self.singlular_vs_plural_es(@@exact_matches)}!"
             puts "You have #{@@correct_choices} correct choice#{self.singlular_vs_plural_s(@@correct_choices)}.\n"
             

             # Change this to accept variable length
             if @@exact_matches == game_code.length
                win
                break
             end
        end
    end

    def self.code_breaker_exact(secret_code, guess)
        @@exact_matches = 0
        (secret_code.length).times do |element|
            if secret_code[element] == guess[element]
                @@exact_matches += 1
                
            end
        end
    end

    

    def self.check_if_present(array_of_choices, user_input)
        @@correct_choices = 0
        array_of_choices.each do |element|
            
            self.choice_eliminated(user_input, element)
        end
    end

    def self.choice_eliminated(array_of_choices, choice)
        new_arr = array_of_choices
        
        if array_of_choices.include?(choice)
            
          new_arr.slice!(array_of_choices.find_index(choice), 1)
          @@correct_choices += 1
        end
        
      end

      def self.win
        puts "You won in #{@@round_counter} round#{self.singlular_vs_plural_s(@@round_counter)}! Congratulations!"
        @@round_counter = 0
      end



      def self.singlular_vs_plural_s(number)
        return 's' if number != 1
    end

    def self.singlular_vs_plural_es(number)
        return 'es' if number != 1
    end

    
    def self.input_checker(length)
        input = ''
        correct_input = (/^[1-9]{#{length}}$/)

        while !(input.match(correct_input)) 
            
            input = gets.chomp.downcase
            break if input == 'q' || input.match(correct_input)
            puts "Please enter a number (1-9) with #{length} digits."
        end
        input
    end

    def self.quit
        puts "Thanks for playing!"
    end

    
end

module Maker
    def code_maker(range, length)
        code_array = Array.new(generate_code(range, length))
    end

    def random_number(number)
        rand(number) + 1
    end

    def generate_code(range, length)
        code = []
        (length).times do 
            number = random_number(range)
            code.push(number.to_s)
        end
        code
    end
end

module Breaker
    @@round_counter = 0
    @@exact_matches = 0
    @@correct_choices = 0
    def play
       
        input = ''

        # Eventually allow user to choose length and complexity
        game_code = code_maker(6,4)
        

        p game_code
        while input != 'q' do
            @@round_counter += 1
            puts "Put in a code."
            input = input_checker(game_code.length)

            if input == 'q'
                quit
                break
            end

             code_breaker_exact(game_code, input.split(''))
             check_if_present(game_code, input.split(''))
             puts "\nYou have #{@@exact_matches} exact match#{singlular_vs_plural_es(@@exact_matches)}!"
             puts "You have #{@@correct_choices} correct choice#{singlular_vs_plural_s(@@correct_choices)}.\n"
             

             
             if @@exact_matches == game_code.length
                win
                play_again
                break
             end
        end
    end


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
        puts "You won in #{@@round_counter} round#{singlular_vs_plural_s(@@round_counter)}! Congratulations!"
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
            puts "\nDo you want to play again? (Y/N)"
            input = gets.chomp.downcase

            case(input)
            when 'y'
                game = PlayGame.new
                game.play
            when 'n'
                exit
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
        
        loop do
            puts "Set the code that the computer will solve!"


        set_code = gets.chomp.downcase

            quit if set_code == 'q'

            if set_code.match((/^[1-9]{4}$/))
                user_input = set_code.split('')
                p user_input
                computer_guess = [random_number(6).to_s, random_number(6).to_s, random_number(6).to_s, random_number(6).to_s]    
                keep_matches(user_input, computer_guess)
                play_again
            end
           
        end
        exit
     end

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
        puts "It took the computer #{@@round_counter} round#{singlular_vs_plural_s(@@round_counter)} to guess your code."
    end

    def new_round(input, guess)
        @@round_counter += 1
        puts "Round #{@@round_counter}"
        puts "\nYou made the secret code #{input}."
        puts "The computer has guessed #{guess}."  
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


        while true
            puts "\nEnter '1' to be the code MAKER."
            puts "Enter '2' to be the code BREAKER."
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

    def mode(maker, breaker)
        maker.generate_code(6,4)
        breaker.play
    end
end

test_arr = ['2', '4', '4', '3']
#Game.input_checker
taco = Computer.new

#p taco.play(test_arr)
#Game.play

game = PlayGame.new

game.play
