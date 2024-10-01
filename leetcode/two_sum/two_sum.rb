def two_sum(numbers, target)
    left_index = 0
    right_index = numbers.length - 1

    until numbers[left_index] + numbers[right_index] == target
        if numbers[left_index] + numbers[right_index] < target
            left_index += 1
        else
            right_index -= 1
        end
    end

    result = Array.new
    result.push(left_index + 1)
    result.push(right_index + 1)
    result
end
