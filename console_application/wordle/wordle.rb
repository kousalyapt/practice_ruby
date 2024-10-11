require 'open-uri'

URL = "https://raw.githubusercontent.com/charlesreid1/five-letter-words/refs/heads/main/sgb-words.txt"

class Wordle    
    def initialize(file_path)
        @dictionary = Set.new(URI.open(URL).readlines.map(&:strip))        
        
        @status = false
        
    end

    def play
        
        loop do
            display_menu
            option = gets.chomp.to_i
            if option == 1
                display_instructions
            elsif option == 2
                start_game
            elsif option == 3
                puts "Thanks for playing! See you next time, Wordle Wizard!"
                break
            else
                puts "#{red("Oops, that’s not a valid option! Try again.")}"
                puts "-------------------------------------------------------"
            end      
        end        
    end

    def display_menu
        puts "-------------------------------------------------------"
        puts "🎉 Lets play Wordle! 🎉"
        puts "-------------------------------------------------------"
        puts "Enter the option"
        puts "1.Learn how to play"
        puts "2.Start the game"
        puts "3.Exit (if you're too scared 😜)"
        puts "-------------------------------------------------------"
    end

    def start_game
        @chances = 6
        @word_to_guess = @dictionary.to_a.sample
        #@word_to_guess = "hotel"
        @wrong_characters = Set.new
        @right_characters = Set.new
        @right_position = Array.new(5,'_')
        puts "-------------------------------------------------------"
        puts "#{green("Get ready... The game starts now!")}"
        puts "You've got #{green(6)} attempts to crack the code!"
        puts "-------------------------------------------------------"
        until @chances == 0
            
            user_word = ""
            until user_word.length == 5
                puts "-------------------------------------------------------"
                puts "Enter a five-letter word:"
                user_word = gets.chomp
                puts "-------------------------------------------------------"
                if user_word.length > 5
                    puts "#{red("*You entered more than five letters. Please enter exactly five letters.")}"
                    puts "-------------------------------------------------------"
                elsif user_word.length < 5
                    puts "#{red("*You entered less than five letters. Please enter exactly five letters.")}"
                    puts "-------------------------------------------------------"
                end
            end

            user_word.downcase!

            if valid_word(user_word)
                if user_word == @word_to_guess
                    #puts "#{green(user_word)}"
                    puts "🎉 Woohoo! You've guessed it! The word is #{green(user_word)}! 🏆"
                    
                    puts "-------------------------------------------------------"
                    @status = true
                    break
                else

                    feedback = Array.new(5, "")   
                    temp_target = @word_to_guess.chars 

                    user_word.chars.each_with_index do |char, i|
                    if char == @word_to_guess[i]
                        feedback[i] = green(char)
                        temp_target[i] = nil 
                        @right_position[i] = char
                        @right_characters.add(char)
                    end
                    @wrong_characters.add(char)
                    end

                    user_word.chars.each_with_index do |char, i|
                    if feedback[i] == green(char) 
                        @wrong_characters.delete(char)
                        next
                    end
                    if temp_target.include?(char)
                        feedback[i] = yellow(char)
                        @right_characters.add(char)
                        @wrong_characters.delete(char)
                         
                        temp_target[temp_target.index(char)] = nil  
                    
                    else
                        feedback[i] = red(char)
                        @wrong_characters.add(char) unless @word_to_guess.include?(char)
                    end
                    end

                end
                @chances = @chances -  1
                
            else
                puts "#{red("*Hmm... that’s not in my dictionary! Please try again with a valid word.")}"
                puts "-------------------------------------------------------"
            end
            puts "-------------------------------------------------------"
            puts feedback.join()
            puts "-------------------------------------------------------"
            puts "Your progress so far: #{@right_position.join(" ")}"
            puts "-------------------------------------------------------"
            puts "Right characters so far: #{@right_characters.to_a.sort.join(", ")}"
            puts "-------------------------------------------------------"
            puts "Wrong guesses: #{@wrong_characters.to_a.sort.join(", ")}"            
            puts "-------------------------------------------------------"
            puts "Careful! You only have #{red(@chances)} chances left!" unless @chances.zero?
        end
        if @status == false
            puts "-------------------------------------------------------"
            puts red("Oh no! You’re out of chances! 😢")
            puts "The word was: #{green(@word_to_guess)}. Better luck next time!"
            puts "-------------------------------------------------------"
        end    

    end

    def valid_word(word)
        @dictionary.include?(word)
    end

    def display_instructions
    
        puts <<-INSTRUCTIONS
You have 6 tries to guess the hidden word. The color of the letters will change to show how close you are.
- #{green("Green")}: The letter is in the word and in the correct position.
- #{yellow("Yellow")}: The letter is in the word but in the wrong position.
- #{red("Red")}: The letter is not in the word.

For example:
    T A B L E
    T, B aren't in the target word at all.
    A, L are in the word but in the wrong spot.
    E is in the word and in the correct spot.
    INSTRUCTIONS
        
    end

    def green(text)
        "\e[32m#{text}\e[0m"  
    end
      
    def yellow(text)
        "\e[33m#{text}\e[0m" 
    end
      
    def red(text)
        "\e[31m#{text}\e[0m"  
    end


end

game = Wordle.new(".\\five_letter_words.txt")
game.play
