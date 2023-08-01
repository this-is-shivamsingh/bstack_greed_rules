require_relative './diceGame'

RSpec.describe 'dice Game' do
  it '#startGame' do
    # Prepare input data for the test
    noOfPlayer = "3\n"
    allow_any_instance_of(Object).to receive(:gets).and_return(noOfPlayer)
    output = capture_stdout { startGame } 
    expect($no_of_player).to be == (3)
  end

  it '#get_dice_rolls' do
    sides = 5
    allow_any_instance_of(Kernel).to receive(:rand).and_return(1, 3, 5, 6, 6)
    result = get_dice_rolls(sides)
    expect(result).to eq([1, 3, 5, 6, 6])
  end

  it '#calculate_score_and_non_scoringDice' do 
    score, nonScoringDice = calculate_score_and_non_scoringDice([1, 3, 5, 6, 6])
    expect(score).to be == 150
    expect(nonScoringDice).to be == 3
  end

  it '#get_user_input_for_continue_playing, if UserInput is y or n' do 
    userAnswer = "y\n"
    allow_any_instance_of(Object).to receive(:gets).and_return(userAnswer)
    $currentPlayerIdx = 2
    captureOutput = capture_stdout do 
        result = get_user_input_for_continue_playing(3)
        expect(result).to be == ('y')
    end

    expect(captureOutput.chomp).to be == ('Do you want to roll 3 Non-Scoring-Dice? (y/n) [ Player 3 ]')
  end

  it '#get_user_input_for_continue_playing, if userInput other than y' do 
    userAnswer = "m\n"
    allow_any_instance_of(Object).to receive(:gets).and_return(userAnswer)
    captureOutput = capture_stdout do 
        result = get_user_input_for_continue_playing(3)
        expect(result).to be == ('n')
    end

    expect(captureOutput.chomp).to include('#### Answer only in y for Yes or n for No ####')
  end

  it '#create_player' do 
     count = 3
     players = createPlayer(count)
     expect(players.length).to eq(count)

     players.each_with_index do |player, index|
       expect(player).to be_a(Player)
       expect(player.id).to eq(index + 1)
       expect(player.totalScore).to eq(0)
     end
  end

  it '#declare_winner' do 
    count = 3
    $players = createPlayer(count)

    maxScore = 0
    player_id = -1
    $players.map do |p|
        p.totalScore = rand(200..1200)
        if p.totalScore > maxScore
            maxScore = p.totalScore
            player_id = p.id
        end
    end

    captureOutput = capture_stdout do 
        result = declare_winner
        expect(result).to be == (player_id)
    end

    expect(captureOutput).to include("### ----> Winner is Player #{player_id} with total Score of #{maxScore} <----- #### ")
  end

  it '#get_user_score' do 
    count = 3
    $players = createPlayer(count)

    $players.map do |p|
        p.totalScore = rand(200..1200)
    end

    # 2nd player is on first index
    scoreOfPlayer2 = $players[1].totalScore
    result = get_user_score(1)
    expect(result).to be == (scoreOfPlayer2)
  end

  it '#play_final' do 
    $no_of_player = 2
    $players = createPlayer($no_of_player)
    $players[0].totalScore = 300
    $players[1].totalScore = 200
    captureOutput = capture_stdout { play_final(0) }
    expect(captureOutput).not_to include("Player 1, Play you final turn...")
    expect(captureOutput).to include("Player 2, Play you final turn...")
  end

  it '#set_user_score' do 
    $no_of_player = 2
    $players = createPlayer($no_of_player)
    $players[0].totalScore = 600
    $players[1].totalScore = 500

    set_user_score(1, 600)
    expect($players[1].totalScore).to be == (1100)
  end

  it '#set_user_score, if score is less then $min_score' do 
    $min_score = 200
    $players = createPlayer($no_of_player)
    $players[0].totalScore = 600
    $players[1].totalScore = 0
    captureOutput = capture_stdout { set_user_score(1, 150) }
    expect($players[1].totalScore).to be == (0)
    expect(captureOutput).to include("Player 2 needs to have a score greater than #{$min_score} in single turn, before scores get acculumated")
  end

  it '#get_frequency' do 
    freq_map = get_freqency([1,2,3,5,3,2,1,1])
    expect(freq_map).to be == ({1=>3, 2=>2, 3=>2, 5=>1})
  end

  it '#play_your_turn' do 
    userAnswer = "n\n"
    allow_any_instance_of(Object).to receive(:gets).and_return(userAnswer)
    allow_any_instance_of(Kernel).to receive(:rand).and_return(1, 3, 6, 6, 6)
    captureOutput = capture_stdout do 
        result = play_your_turn(1, 5, false)
        expect(result).to be (700)
    end
  end
  
  it '#next_turn' do
    result = next_turn(2,3)
    expect(result).to be == (0)
    result = next_turn(1, 3)
    expect(result).to be (2)
  end
end

def capture_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
  end