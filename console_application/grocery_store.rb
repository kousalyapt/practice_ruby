class GroceryStore
    VALID_DENOMINATIONS = [2000,500,200,100,50,20,10,5,2,1]

    def initialize()
        @cash_box = Hash.new

        puts "Welcome!!!"

        puts "------------------------------------------"

        puts "Please enter the quantity of each denomination available in your store:"

        VALID_DENOMINATIONS.each do |denomination|
        
            @cash_box[denomination] = get_valid_quantity(denomination)

        end

        puts "------------------------------------------"
    end

    def start_transaction

        loop do
            puts "Please choose an action:"
            puts "1.Transaction"
            puts "2.Exit"
            puts "------------------------------------------"

            user_choice = gets.chomp.to_i

            puts "------------------------------------------"

            break if user_choice != 1

            product_price = get_product_price

            user_currency = get_user_currency

            total_user_payment = user_currency&.sum

            total_user_payment < product_price ? 
            puts("The amount provided is insufficient to cover the product price. You need to pay Rs.#{ product_price - total_user_payment } more" ):
            process_transaction(total_user_payment, product_price, user_currency)
              
            puts "------------------------------------------"
            
        end
    end

    def get_valid_quantity( denomination )

        quantity = 0

        while quantity <= 0
            begin 
            puts "Enter the no.of Rs.#{denomination}:"
            quantity = Integer(gets.chomp)

            if quantity < 0 
                puts "*Please enter a valid number."
            else
                break
            end

            rescue ArgumentError
                puts "*Please enter a valid number."
            end

            
        end
        quantity
    end

    def get_product_price

        product_price = 0

        while product_price <= 0
            puts "Enter the total price of the product:"
            product_price = gets.chomp.to_i
            puts "*Please enter a valid amount." if product_price <= 0
        end

        product_price

    end

    def get_user_currency

        puts "Enter the denominations provided by the customer (comma-separated):"
        user_currency = gets.chomp.split(',').map(&:to_i)
             
        puts "------------------------------------------"

        return user_currency if validate_denominations?(user_currency)

        puts "The denominations provided are not valid. Please try again."
        start_transaction

    end

    def total_amount
        2000 * @cash_box[2000] + 500 * @cash_box[500] + 200* @cash_box[200] + 100 * @cash_box[100] + 50 * @cash_box[50] + 20 * @cash_box[20] + 10 * @cash_box[10] + 5 * @cash_box[5] + 2 * @cash_box[2] + @cash_box[1]
       
    end

    def process_transaction(total_user_payment, product_price, user_currency)

        balance = total_user_payment - product_price
                
        if balance > total_amount + total_user_payment
            puts "Sorry, we cannot provide change for this transaction. Please provide exact payment."

        else
            user_currency.each {|currency| @cash_box[currency] += 1}

            calculate_change(user_currency, balance)
 
        end

        puts "------------------------------------------"
        puts "------------------------------------------"
        puts "AVAILABLE AMOUNT IN THE CASHBOX"
        @cash_box.each {|key,value| puts "Rs.#{key} : #{value}" }
        puts "TOTAL : Rs.#{total_amount}"
        puts "------------------------------------------"

    end

    def calculate_change(user_currency, balance)
        @change_to_be_given = Hash.new

                @cash_box.each do |key, value|

                    break if balance == 0                    

                    if balance / key != 0 && value > 0
                        no_of_notes = balance / key
        
                        if(@cash_box[key] <= no_of_notes)
                            @change_to_be_given[key] = @cash_box[key]
                            balance = balance - (@cash_box[key]*key)
                        else
                            @change_to_be_given[key] = no_of_notes
                            balance = balance - (no_of_notes*key)
                        end
                    end

                end

                display_change(balance, user_currency)
            
    end

    def validate_denominations?(denominations)
        
        denominations.all? {|amount| VALID_DENOMINATIONS.include?(amount)}
    end

    def display_change(balance, user_currency)
        
        if balance > 1
            puts "Sorry, we cannot provide change for this transaction. Please collect your cash or provide exact payment."
            revert_cash(user_currency)
        else
            print "Give a one ruppee chocolate." if balance == 1
                         
            if @change_to_be_given.empty?
                puts "NO CHANGE TO BE GIVEN"
            else
                puts "CHANGE TO BE GIVEN: "
                @change_to_be_given.each do |key, value| 
                    puts "Rs.#{key} : #{value}"
                    @cash_box[key] -= value
                end               
            end                   
        end

    end

    def revert_cash(user_currency)
        user_currency.each {|currency| @cash_box[currency] -= 1}
    end
    
end

grocery = GroceryStore.new
grocery.start_transaction
