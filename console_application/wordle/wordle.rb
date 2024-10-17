require 'open-uri'


URL = "https://raw.githubusercontent.com/charlesreid1/five-letter-words/refs/heads/main/sgb-words.txt"

class Wordle    
    def initialize(file_path)
        @dictionary = Set.new            
        @game_won = false        
        begin
            @dictionary = Set.new(URI.open(URL).readlines.map(&:strip))
        rescue SocketError => e
            puts "Network error. Please check your internet connection."
            exit 
        rescue OpenURI::HTTPError => e
            puts "HTTP error. Unable to retrieve the word list."
            exit 
        rescue StandardError => e
            puts "An error occurred. Please try again later."
            exit 
        end
    end

    def handle_user_selection        
        loop do
            display_game_options
            user_choice = gets.chomp.to_i
            if user_choice == 1
                display_instructions
            elsif user_choice == 2
                start_game
            elsif user_choice == 3
                puts cyan_font("Thanks for playing! See you next time, Wordle Wizard!")
                break
            else
                puts "#{red_font("Oops, that’s not a valid option! Try again.")}"
                puts "-------------------------------------------------------"
            end      
        end        
    end

    def display_game_options
        puts "-------------------------------------------------------"
        puts "🎉 #{cyan_font("Lets play Wordle!")} 🎉"
        puts "-------------------------------------------------------"
        puts "Enter the option"
        puts "#{yellow_font("1.Learn how to play")}"
        puts "#{green_font("2.Start the game")}"
        puts "#{red_font("3.Exit ")}"
        puts "-------------------------------------------------------"
    end

    def start_game

        initialize_game_state  
        display_welcome_message
        play_game
           
    end

    def play_game

        until @remaining_attempts == 0    
            break if play_turn
        end    
        display_failure_message unless @game_won

    end

    def initialize_game_state
        @remaining_attempts = 6
        @secret_word = @dictionary.to_a.sample
        @wrong_characters = Set.new
        @right_characters = Set.new
        @correctly_placed_letters = Array.new(5, '_')
        @attempted_words = Array.new
        @game_won = false
    end

    def play_turn
        
        puts @attempted_words
        show_current_status unless @remaining_attempts == 0 || @remaining_attempts == 6
          
        player_guess = get_user_input
      
        if valid_word(player_guess)
             return handle_valid_guess(player_guess)
        else
            display_invalid_word_message
        end
    end

    def handle_valid_guess(player_guess)
        if check_win_condition(player_guess)
            display_success_message
            return true
        else
            check_guess_accuracy(player_guess)
            @remaining_attempts -= 1
            return false
        end
    end
      
      
    def display_welcome_message
        puts "-------------------------------------------------------"
        puts "#{green_font("Get ready... The game starts now!")} "
        puts "You've got #{green_font(6)} attempts to crack the code!"
    end
      
    
      
    def get_user_input
        player_guess = ""
        until player_guess.length == 5
          puts "-------------------------------------------------------"
          puts "Enter a five-letter word:"
          player_guess = gets.chomp.strip.downcase
          puts "-------------------------------------------------------"
          if player_guess.length == 0
            puts "#{red_font("Please enter a five letter word.")}"
          elsif player_guess.length > 5
            puts "#{red_font("*You entered more than five letters. Please enter exactly five letters.")}"
          elsif player_guess.length < 5
            puts "#{red_font("*You entered less than five letters. Please enter exactly five letters.")}"
          end
        end
        player_guess
    end
      
    def check_win_condition(player_guess)
        if player_guess == @secret_word
          @game_won = true
          true
        else
          false
        end
    end
      
    def check_guess_accuracy(player_guess)
        validated_user_word = Array.new(5, "")
        secret_word_clone = @secret_word.chars 

        identify_correctly_placed_letters(player_guess, validated_user_word, secret_word_clone)

        identify_misplaced_letters(player_guess, validated_user_word, secret_word_clone )
            
        @attempted_words.push(validated_user_word.join(" "))
    end

    def identify_correctly_placed_letters(player_guess, validated_user_word, secret_word_clone)
        player_guess.chars.each_with_index do |char, i|
            if char == @secret_word[i]
                validated_user_word[i] = green_font(char)
                secret_word_clone[i] = nil
                @correctly_placed_letters[i] = char
                @right_characters.add(char)
            end
              @wrong_characters.add(char)
        end
    end

    def identify_misplaced_letters(player_guess, validated_user_word, secret_word_clone )
        player_guess.chars.each_with_index do |char, i|
            if validated_user_word[i] == green_font(char)
                @wrong_characters.delete(char)
                next
            end
            if secret_word_clone.include?(char)
                validated_user_word[i] = yellow_font(char)
                @right_characters.add(char)
                @wrong_characters.delete(char)
                secret_word_clone[secret_word_clone.index(char)] = nil
            else
                validated_user_word[i] = red_font(char)
                @wrong_characters.add(char) unless @secret_word.include?(char)
            end
        end
    end
      
    def display_invalid_word_message
        puts "#{red_font("*Please try again with a valid word.")}"
    end
      
      
    def valid_word(word)
        @dictionary.include?(word)
    end

    def display_instructions
    
        puts <<-INSTRUCTIONS
        #{yellow_font("You have 6 tries to guess the hidden word.")}
        #{cyan_font("The color of the letters will change to show how close you are:")}
        - #{green_font("Green")}: The letter is in the word and in the correct position.
        - #{yellow_font("Yellow")}: The letter is in the word but in the wrong position.
        - #{red_font("Red")}: The letter is not in the word.

        #{cyan_font("For example:")}
        #{yellow_font("T A B L E")}
        - T, B aren't in the target word at all.
        - A, L are in the word but in the wrong spot.
        - E is in the word and in the correct spot.
        INSTRUCTIONS

    end

    def show_current_status

        puts "Your progress so far: #{@correctly_placed_letters.join(" ")}"
        puts "-------------------------------------------------------"
        puts "Right characters so far: #{@right_characters.to_a.sort.join(", ")}" unless @right_characters.empty?
        puts "-------------------------------------------------------"
        puts "Wrong guesses: #{@wrong_characters.to_a.sort.join(", ")}" unless @wrong_characters.empty?        
        puts "-------------------------------------------------------"        
        puts red_font("Careful! You only have #{@remaining_attempts} chances left!") unless @remaining_attempts.zero? || @remaining_attempts == 6
        show_chances_left unless @remaining_attempts == 6
    end

    def show_chances_left
        bar = '🟢' * @remaining_attempts + '🔴' * (6 - @remaining_attempts)
        puts bar
    end

    def display_success_message
        puts "🎉 #{green_font("Congratulations, Wordle Master! The word was #{green_font(@secret_word)}!")}"
        puts "🎉🏆 #{cyan_font("You're a genius!")}"
    end
    
    def display_failure_message
        puts "-------------------------------------------------------"
        puts red_font("Oh no! You’re out of chances! 😢")
        puts "The word was #{green_font(@secret_word)}."
        puts cyan_font("Better luck next time!")
        puts "-------------------------------------------------------"
    end    

    def green_font(text)
        "\e[32m#{text}\e[0m"  
    end
      
    def yellow_font(text)
        "\e[33m#{text}\e[0m" 
    end
      
    def red_font(text)
        "\e[31m#{text}\e[0m"  
    end

    def cyan_font(text)
        "\e[36m#{text}\e[0m"
    end
    
end

game = Wordle.new(".\\five_letter_words.txt")
game.handle_user_selection        
