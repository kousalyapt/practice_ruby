require 'open-uri'

URL = "https://raw.githubusercontent.com/charlesreid1/five-letter-words/refs/heads/main/sgb-words.txt"

class Wordle    
    def initialize(file_path)
        @dictionary = Set.new(URI.open(URL).readlines.map(&:strip))
        
        @chances = 6
        @status = false
        @wrong_characters = Set.new
        @right_characters = Set.new
        @right_position = Array.new(5,'_')
    end

    def play
        loop do
            puts "-------------------------------------------------------"
            puts "Lets play Wordle!!!"
            puts "-------------------------------------------------------"
            puts "Enter the option"
            puts "1.Instructions to Play"
            puts "2.Start the game"
            puts "3.Exit"
            puts "-------------------------------------------------------"
            option = gets.chomp.to_i
            if option == 1
                display_instructions
            elsif option == 2
                @word_to_guess = @dictionary.to_a.sample
                #@word_to_guess = "hotel"
            #     character_count = Hash.new(0)
            # @word_to_guess.chars.each { |ch| character_count[ch] += 1 }
                puts "-------------------------------------------------------"
                puts "Game starts!!"
                puts "-------------------------------------------------------"
                until @chances == 0
                    user_word = ""
                    until user_word.length == 5
                        puts "-------------------------------------------------------"
                        puts "Enter a five-letter word:"
                        user_word = gets.chomp
                        puts "-------------------------------------------------------"

                        if user_word.length > 5
                            puts "*You entered more than five letters. Please enter exactly five letters."
                            puts "-------------------------------------------------------"
                        elsif user_word.length < 5
                            puts "*You entered less than five letters. Please enter exactly five letters."
                            puts "-------------------------------------------------------"
                        end
                    end

                    user_word.downcase!
                    if valid_word(user_word)
                        if user_word == @word_to_guess
                            puts "\e[32m#{user_word}\e[0m"
                            puts "You guessed the word!! You won!!"
                            
                            puts "-------------------------------------------------------"
                            @status = true
                            break
                        else
                            included_atleast_one = false
                            display_word = ""
                            user_word.chars.each_with_index do |user_ch, user_ind|
                                
                                if @word_to_guess.include? (user_ch)
                                    
                                    included_atleast_one = true
                                    indices = []
                
                                    @word_to_guess.chars.each_with_index do |character,index|
                                        indices << index if character == user_ch
                                    end
                                    
                    
                                    if indices.include?(user_ind)
                                        display_word += "#{green(user_ch)}"
                                        
                                        indices.delete(user_ind)
                                        @right_position[user_ind] = user_ch
                                        @right_characters.add(user_ch)
                                    else
                                        display_word += "#{yellow(user_ch)}"
                                        
                                        @right_characters.add(user_ch)
                                    end
                                else
                                    display_word += "#{red(user_ch)}"
                                    @wrong_characters.add(user_ch)
                                end
                                
                            end
                            puts display_word
                            puts "No letters are matched" if included_atleast_one == false
                        end
                        @chances = @chances -  1
                    else
                        puts "*Enter a valid word"
                        puts "-------------------------------------------------------"
                    end
                    puts "-------------------------------------------------------"
                    puts "The word to guess: #{@right_position.join(" ")}" unless @right_position.all?{|ele| ele == '_'}
                    puts "-------------------------------------------------------"
                    puts "Right Characters : #{@right_characters.to_a}" if @right_characters.length > 0
                    puts "-------------------------------------------------------"
                    puts "Wrong Characters : #{@wrong_characters.to_a}" if @wrong_characters.length > 0
                    puts "-------------------------------------------------------"
                end
                if @status == false
                    puts "-------------------------------------------------------"
                    puts "You lost"
                    puts "The word is #{@word_to_guess}"
                    puts "-------------------------------------------------------"
                end    

            elsif option == 3
                break
            else
                puts "Enter valid option."
                puts "-------------------------------------------------------"
            end
       
        end
        
    end

    def valid_word(word)
        @dictionary.include?(word)
    end

    def display_instructions
        puts "-------------------------------------------------------"
        puts "  
        You have to guess the hidden word in 6 tries and the color of the letters changes to show how close you are.
        To start the game, just enter any word, 

                for example:
                    
                            T A B L E

                T , B aren't in the target word at all.
                A , L is in the word but in the wrong spot.
                E is in the word and in the correct spot.

            Another try to find matching letters in the target word.

                            F L A S H

                            So close!

                            F L A M E

                            Got it! 🏆"
        puts "-------------------------------------------------------"
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
