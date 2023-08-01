def get_user_input_for_continue_playing(nonScoringDice)
    threshold_limit = 0
    # Set it to 5 attempts, so it won't get into an infinite loops.
    while threshold_limit < 5
        puts "Do you want to roll #{nonScoringDice} Non-Scoring-Dice? (y/n) [ Player #{$currentPlayerIdx + 1} ]"
        userAnswer = gets.chomp()
        if userAnswer == 'y' || userAnswer == 'n'
            return userAnswer
        else 
            puts "#### Answer only in y for Yes or n for No ####"
            threshold_limit+=1
            next
        end
    end
    return 'n'
end