class GroceryStore
    def initialize()
        @available_no_of_notes = Hash.new

        puts "Welcome!!!"

        puts "------------------------------------------"

        puts "Enter the no.of 2000 ruppee notes"
        @available_no_of_notes[2000] = gets.chomp.to_i

        puts "Enter the no.of 500 ruppee notes"
        @available_no_of_notes[500] = gets.chomp.to_i

        puts "Enter the no.of 200 ruppee notes"
        @available_no_of_notes[200] = gets.chomp.to_i

        puts "Enter the no.of 100 ruppee notes"
        @available_no_of_notes[100] = gets.chomp.to_i

        puts "Enter the no.of 50 ruppee notes"
        @available_no_of_notes[50] = gets.chomp.to_i

        puts "Enter the no.of 20 ruppee"
        @available_no_of_notes[20] = gets.chomp.to_i

        puts "Enter the no.of 10 ruppee"
        @available_no_of_notes[10] = gets.chomp.to_i

        puts "Enter the no.of 5 ruppee"
        @available_no_of_notes[5] = gets.chomp.to_i

        puts "Enter the no.of 2 ruppee coins"
        @available_no_of_notes[2] = gets.chomp.to_i

        puts "Enter the no.of 1 ruppee coins"
        @available_no_of_notes[1] = gets.chomp.to_i

        puts "------------------------------------------"
    end

    def change

        loop do
            puts "1.Transaction"
            puts "2.Exit"

            puts "------------------------------------------"

            option_to_proceed = gets.chomp.to_i

            puts "------------------------------------------"

            break if option_to_proceed == 2

            puts "Enter the product amount"
            product_amount = gets.chomp.to_i

            puts "Enter the user currency denominations"
            currency_denominations = gets.chomp
             
            puts "------------------------------------------"

            splitted_currency = currency_denominations.split(',')

            given_currency = splitted_currency.map { |num| num.to_i}

            unless validate_denominations?(given_currency)
                puts "Enter valid denominations"
                break
            end

            total_user_currency = given_currency.sum

            if total_user_currency < product_amount
                puts "Insufficient Amount"

            elsif total_user_currency >= product_amount

                balance_to_be_given = total_user_currency - product_amount
                
                if balance_to_be_given > total_amount + total_user_currency
                    puts "No change. Please provide exact change!!!"

                else
                    given_currency.each {|currency| @available_no_of_notes[currency] += 1}

                    @change_to_be_given = Hash.new

                    @available_no_of_notes.each do |key, value|

                        if balance_to_be_given == 0
                            break
                        end

                        if balance_to_be_given / key != 0 && value > 0
                            no_of_notes = balance_to_be_given / key
        
                            if(@available_no_of_notes[key] <= no_of_notes)
                                @change_to_be_given[key] = @available_no_of_notes[key]
                                balance_to_be_given = balance_to_be_given - (@available_no_of_notes[key]*key)
                            else
                                @change_to_be_given[key] = no_of_notes
                                balance_to_be_given = balance_to_be_given - (no_of_notes*key)
                            end
                        end

                    end

                    if balance_to_be_given > 1
                        puts "NO CHANGE. PLEASE PROVIDE EXACT CHANGE!!!"
                        given_currency.each {|currency| @available_no_of_notes[currency] -= 1}
                    else
                        
                        if @change_to_be_given.empty?
                            puts "NO CHANGE TO BE GIVEN"
                        else
                            puts "CHANGE TO BE GIVEN: "
                            @change_to_be_given.each do |key, value| 
                            puts "#{key} : #{value}"
                            @available_no_of_notes[key] -= value
                            end
            
                            if balance_to_be_given == 1
                            puts "Give a one ruppee chocolate"
                            end
                        end
                    end                
                end
                puts "------------------------------------------"
                puts "AVAILABLE AMOUNT"
                    @available_no_of_notes.each {|key,value| puts "#{key} : #{value}" }
                puts "------------------------------------------"

            end
        end
    end

    def total_amount
        2000 * @available_no_of_notes[2000] + 500 * @available_no_of_notes[500] + 200* @available_no_of_notes[200] + 100 * @available_no_of_notes[100] + 50 * @available_no_of_notes[50] + 20 * @available_no_of_notes[20] + 10 * @available_no_of_notes[10] + 5 * @available_no_of_notes[5] + 2 * @available_no_of_notes[2] + @available_no_of_notes[1]
       
    end

    def validate_denominations?(denominations)
        valid_denominations = [1,2,5,10,20,50,100,200,500,2000]
        denominations.all? {|amount| valid_denominations.include?(amount)}
    end
    
end

grocery = GroceryStore.new
grocery.change
