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
            number = Game.random_number(range)
            code.push(number.to_s)
        end
        code
    end

    def self.play
       
        input = ''

        game_code = Game.code_maker(6,4)
        tester = Game.new
        while input != 'q'.downcase do
            @@round_counter += 1
            puts "Put in a code."
            input = gets.chomp
             Game.code_breaker_exact(game_code, input.split(''))
             
            
             p Game.check_if_present(game_code, input.split(''))
             puts "You have #{@@exact_matches} exact matches!"
             puts "You have #{@@correct_choices} correct choices."

             if @@exact_matches == 4
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
            
            Game.choice_eliminated(user_input, element)
        end
    end

    def self.choice_eliminated(array_of_choices, choice)
        new_arr = array_of_choices
        
        if array_of_choices.include?(choice)
            
          new_arr.slice!(array_of_choices.find_index(choice), 1)
          @@correct_choices += 1
          puts "#{choice} was eliminated."
        end
        
      end

      def self.win
        puts "You won in #{@@round_counter} rounds! Congratulations!"
        @@round_counter = 0
      end



      def self.singlular_vs_plural(number)
        return 's' if number == 1
    end

    def clues(secret_code, guess)
        #puts "You have x #{number_vs_numbers} correct with y #{number_vs_numbers} in the correct position."
    end
end

class Computer
  
end

class Player
    attr_reader :name
   def initialize(name)
    @name = name
   end
end













Game.play




