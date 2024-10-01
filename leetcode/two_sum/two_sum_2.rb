def two_sum(numbers, target)
 
    num_list = Hash.new

    numbers.each_with_index do |element, index|
        difference = target - element
        if num_list.key?(difference)
            index2 = num_list[difference]
            result = Array.new
            result.push(index + 1)
            result.push(index2 + 1)
            return result.sort
        end
        num_list[element] = index             
    end
end
