require 'card'
require 'score'

class String
  def capitalize_each
    self.split.map { |x| x.capitalize }.join(" ")
  end
end

class Game

  class Config
    @@actions = ['new', 'quit', 'hit', 'stand', 'again', 'high scores']
    def self.actions
      return @@actions
    end
  end

  def initialize(path=nil)
    Score.filepath = path
    Score.file_usable? ? nil : Score.create_file
    @hand = 0
    @card_count = 0
    @dealer_hand = 0
    @cash = 10000
    @name = nil
    @payout = 0
  end

  def launch!
    intro_animation
    intro
    result = nil
    until result == :quit
      action = get_action
      result = game_action(action)
    end

  end

  def get_action
    action = nil
    until Game::Config.actions.include?(action)
      print "> "
      action = gets.downcase.chomp
      end
    return action
  end

  def game_action(action)
    case action
    when "new"
      @hand < 21 && @payout = 0 ? new : nil
    when "quit"
      quit
    when "hit"
      @card_count > 0 && @dealer_hand < 11 ? game_action("new") : nil
    when "stand"
      if @payout == nil
        @hand < 21 && @card_count > 0 ? game_over : nil
      else
        nil
      end
    when "again"
      if @card_count == 0
        nil
      else
      @hand = 0
      @card_count = 0
      @dealer_hand = 0
      @bet = 0
      @payout = 0
      game_action("new")
    end
    when "high scores"
      scores = Score.high_scores
      output_high_scores(scores)
    end
  end

  def bet
    if @cash == 10000
      output_game_header("Please enter a bet:","You currently have $10000","The table minimum is $5")
    else
      output_game_header("Please enter a bet:","You currently have $#{@cash}","The table minimum is $5")
    end
    answer = 0
    until answer.between?(5, @cash) || answer == "quit"
      print ">"
      answer = gets.chomp
      answer == "quit" ? quit : answer = answer.to_i
    end
    @bet = answer.to_i
  end

  def decision
      output_game_header("You have #{@card_count} cards totaling #{@hand}.",
      "Enter \'hit\' to hit", "Enter \'stand\' to stand")
  end

  def get_name
    output_game_header("Please enter your name to continue: ")
    name = nil
    until /[[:alpha:]]/ =~ name
      name = gets.chomp
      @name = name.downcase
    end
  end

  def new
      @name == nil ? get_name : nil
      case @card_count
      when 0
        bet
        first_card = Card.new
        second_card = Card.new
        dealer_card = Card.new
        @dealer_hand = dealer_card.value
        output_game_header("Your first card is the #{first_card.type} of #{first_card.suit}.",
        "Your second card is the #{second_card.type} of #{second_card.suit} ",
        "The dealer has the #{dealer_card.type} of #{dealer_card.suit} showing.")
        @hand = first_card.value
        @hand += second_card.value
        @card_count += 2
      else
        next_card = Card.new
        output_game_header("Your new card is the #{next_card.type} of #{next_card.suit}.")
        @hand += next_card.value
        @card_count += 1
      end
    @hand >= 21 ? game_over : decision
  end

  def win
    output_game_header("Congratulations #{@name.capitalize_each}! You Won!",
    "You had #{@hand}", "The dealer had #{@dealer_hand}", "You bet $#{@bet}, and you won $#{@payout}")
  end

  def lose
    output_game_header("You lost. Better luck next time #{@name.capitalize_each}!",
    "You had #{@hand}", "The dealer had #{@dealer_hand}","You bet $#{@bet}, and you lost $#{@payout}")
    @cash <= 0 ? game_over : nil
  end

  def push
    output_game_header("Push!", "You had #{@hand}", "The dealer had #{@dealer_hand}")
  end

  def quit
    output_game_header("Are you sure you want to quit (yes/no)?")
    answer = nil
    until ["yes", "no"].include?(answer)
    answer = gets.chomp
      if answer == "yes"
        if @name == nil
          outro
        elsif Score.score_exists?(@name)
          outro
        else
          output_game_header("Saving score...")
          Score.save({:name => @name, :cash => @cash})
          outro
        end
        exit!
      elsif answer == "no"
        @card_count == 0 ? intro : decision
      else
        output_game_header("I'm sorry, I don't understand that command.","Enter \'yes\' to quit","Enter \'no\' to continue")
      end
    end
  end

  def game_over

    if @cash <= 0
      output_game_header("Looks like you ran out of cash!", "Game over")
      exit!
    else
      nil
    end

    until @dealer_hand >= 17
      @dealer_hand += (1 + rand(9))
    end
    if @hand == 21 && @dealer_hand != 21
      @payout = (@bet * 1.5).to_i
      @cash += @payout
      win
    elsif @hand > 21
      @payout = @bet
      @cash -= @payout
      lose
    elsif @dealer_hand > 21
      @payout = @bet
      @cash += @payout
      win
    elsif @hand > @dealer_hand
      @payout = @bet
      @cash += @payout
      win
    elsif @hand < @dealer_hand
      @payout = @bet
      @cash -= @payout
      lose
    else
      push
    end
    new_game
  end

  def new_game
    output_game_header("Would you like to play again #{@name.capitalize_each}?","Enter \'again\' to play again","Enter \'quit\' to quit")
  end

  def output_game_header(text, *more)
    print ">" * 90
    puts "\n\n#{text.center(90)}\n"
    more.each do |txt|
      puts "\n#{txt.center(90)}\n"
    end
    print "\n" + "<" * 90 + "\n"
  end

  def output_high_scores(high_scores=[])
    print ">" * 90 + "\n\n"
    print "Top 10 Blackjack Scores:".center(90) +"\n\n"
    print "   " + "Name:".ljust(40)
    print " " + "Winnings:\n"
    print "." * 90 + "\n\n"
    pos = 1
    high_scores.first(10).each do |score|
      line = "#{pos}."
      cash = score[:cash]
      name = score[:name].capitalize_each
      line << " " + name
      line << ("$ " + cash).rjust(50 - name.length - pos.to_s.length)
      pos += 1
      puts line
    end
    print "\n" + "<" * 90 + "\n"
  end

  def intro
    print ">" * 90 +"\n\n\n"
    puts "Welcome to Blackjack:".center(90) + "\n\n"
    puts "Enter \'new\' to start a new game".center(90) + "\n\n" +  "Enter \'high scores\' to see high scores".center(90) + "\n\n" + "Enter \'quit\' to quit".center(90) + "\n\n\n"
    print "<" * 90 +"\n\n"
  end

  def outro
    output_game_header("Thanks for playing Blackjack!", "Goodbye!")
  end

  def intro_animation
    print "\n\n\n"
    print '
 /$$$$$$$  /$$                     /$$                /$$$$$                    /$$
| $$__  $$| $$                    | $$               |__  $$                   | $$
| $$  \ $$| $$  /$$$$$$   /$$$$$$$| $$   /$$            | $$ /$$$$$$   /$$$$$$$| $$   /$$
| $$$$$$$ | $$ |____  $$ /$$_____/| $$  /$$/            | $$|____  $$ /$$_____/| $$  /$$/
| $$__  $$| $$  /$$$$$$$| $$      | $$$$$$/        /$$  | $$ /$$$$$$$| $$      | $$$$$$/
| $$  \ $$| $$ /$$__  $$| $$      | $$_  $$       | $$  | $$/$$__  $$| $$      | $$_  $$
| $$$$$$$/| $$|  $$$$$$$|  $$$$$$$| $$ \  $$      |  $$$$$$/  $$$$$$$|  $$$$$$$| $$ \  $$
|_______/ |__/ \_______/ \_______/|__/  \__/       \______/ \_______/ \_______/|__/  \__/
'
    print "\n\n\n"
  end

end
