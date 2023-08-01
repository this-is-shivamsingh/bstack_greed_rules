require_relative 'helper'
require_relative 'userInput'
require_relative 'player'

$currentPlayerIdx = -1
$no_of_player = 0
$max_score = 3000
$min_score = 300
$no_of_dices = 5
def set_user_score(currentPlayerIdx, totalScore)
    currentScore = $players[currentPlayerIdx].totalScore
    if currentScore == 0 && totalScore < $min_score
        puts "Player #{currentPlayerIdx + 1} needs to have a score greater than #{$min_score} in single turn, before scores get acculumated"
        return
    end
    $players[currentPlayerIdx].totalScore += totalScore 
end

def get_user_score(idx)
    return $players[idx].totalScore
end

def declare_winner
    maxScore = 0
    playerId = -1
    for i in 0..($no_of_player - 1)
        score = $players[i].totalScore
        if score > maxScore
            maxScore = score
            playerId = $players[i].id
        end
    end

    puts " ### ----> Winner is Player #{playerId} with total Score of #{maxScore} <----- #### "
    return playerId
end

def play_your_turn(currentPlayerIdx, available_dice = 5, isFinalTurn = false)
    totalScore = 0
    while available_dice > 0
        dice_roll_values = get_dice_rolls(available_dice)
        puts "Player #{currentPlayerIdx + 1} rolls: #{dice_roll_values.join(' ')}"
        
        score, non_scoring_dice = calculate_score_and_non_scoringDice(dice_roll_values)
        puts "Score in this turn: #{score}"

        if non_scoring_dice == 0
            break
        end
    
        if score == 0
            puts " ## Since your Score comes out to be 0 in this turn, so your accumulated score will becomes 0"
            totalScore = 0
            break
        end
        totalScore += score
        available_dice = non_scoring_dice

        puts "Total Score Accumulated in this round: #{totalScore}"
        puts "No. of Non-Scoring-Dices are: #{available_dice}"

        userAnswer = 'n'
        if available_dice > 0
            userAnswer = get_user_input_for_continue_playing(available_dice)
        end

        if userAnswer == 'n'
            break
        end
    end
    return totalScore
end

def play_final(excludedPlayerIdx)
    puts " ##### FINAL ROUND #####"
    puts "Since Player #{excludedPlayerIdx + 1} have score >= #{$max_score}, we will go for final turn"
    for i in 0..($no_of_player - 1)
        if i == excludedPlayerIdx
            next
        end
        puts "Player #{i + 1}, Play you final turn..."
        $currentPlayerIdx = i
        score = play_your_turn(i, 5, true)
        set_user_score(i, score)
        currUserScore = get_user_score(i)
        puts "Player #{i + 1} TOTAL SCORE: #{currUserScore}"
    end
end

def createPlayer(count)
    players = []
    cnt = 1
    count.times do
        players.push(Player.new(cnt))
        cnt += 1
    end
    return players
end

def startGame
    "Enter the no. of players: "
    $no_of_player = gets
    $no_of_player = $no_of_player.to_i
    $players = createPlayer($no_of_player.to_i)

    isFinalTurn = false
    excludedPlayerIdx = -1
    while !isFinalTurn
        $currentPlayerIdx = next_turn($currentPlayerIdx, $no_of_player)
        score = play_your_turn($currentPlayerIdx, $no_of_dices, false)

        set_user_score($currentPlayerIdx, score)
        currUserScore = get_user_score($currentPlayerIdx)
        puts "Player #{$currentPlayerIdx + 1} TOTAL SCORE: #{currUserScore}"

        if currUserScore >= $max_score
            # This player is excluded to play in final round, since Highest score is achived
            excludedPlayerIdx = $currentPlayerIdx
            isFinalTurn = true
        end
    end

    play_final(excludedPlayerIdx)
    declare_winner()
    puts "### SCORE BOARD ### "
    puts $players.map{ |p| " player: #{p.id}, Score: #{p.totalScore}"}
end

