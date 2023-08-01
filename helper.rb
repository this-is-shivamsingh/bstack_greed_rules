def calculate_score_and_non_scoringDice(dice_roll_values)
    freq_map = get_freqency(dice_roll_values)
    # for 1
    total  = 0
    non_scoring_dice = 0
    one = freq_map.fetch(1, 0)
    two = freq_map.fetch(2, 0)
    three = freq_map.fetch(3, 0)
    four = freq_map.fetch(4, 0)
    five = freq_map.fetch(5, 0)
    six = freq_map.fetch(6, 0)

    while one > 0
        min = [one, 3].min
        if min == 3
            total += 1000
            one -= min;
        else 
            total += 100
            one -= 1
        end
    end

    # for 2
    while two > 0
        min = [two, 3].min
        if min == 3
            total += 200
            two -= min;
        else
            non_scoring_dice += min
            break
        end
    end

    # for 3
    while three > 0
        min = [three, 3].min
        if min == 3
            total += 300
            three -= min;
        else
            non_scoring_dice += min
            break
        end
    end

    # for 4
    while four > 0
        min = [four, 3].min
        if min == 3
            total += 400
            four -= min;
        else
            non_scoring_dice += min
            break
        end
    end

    # for 5
    while five > 0
        min = [five, 3].min
        if min == 3
            total += 1000
            five -= min;
        else 
            total += 50
            five -= 1
        end
    end

    # for 6
    while six > 0
        min = [six, 3].min
        if min == 3
            total += 600
            six -= min;
        else
            non_scoring_dice += min
            break
        end
    end
    
    return [total, non_scoring_dice]
end

def get_dice_rolls(sides)
    values = []
    sides.times do 
        values << rand(1..6)
    end
    return values
end

def get_freqency(values)
    freq_map = Hash.new(0)
    values.each do |value|
        freq_map[value] += 1
    end
    return freq_map
end

def next_turn(currentPlayer, totalPlayer)
    if(totalPlayer == 0)
        puts "No of Players should be greater than 0"
        return
    end
    currentPlayer = (currentPlayer + 1)%(totalPlayer)
    return currentPlayer
end