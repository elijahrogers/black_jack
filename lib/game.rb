require 'card'


#Classes
class Game
  class Config
    @@actions = ['new', 'quit', 'hit', 'stand', 'new game']
    def self.actions
      return @@actions
    end
  end

  def initialize
    @hand = 0
    @card_count = 0
    @dealer_hand = 0
    @cash = 10000
  end

  def launch!
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
      @hand < 21 ? new : nil
    when "quit"
      quit
    when "hit"
      game_action("new")
    when "stand"
      @hand < 21 ? game_over : nil
    when "new game"
      @hand = 0
      @card_count = 0
      @dealer_hand = 0
      game_action("new")
    end
  end

  def decision
      output_game_header("You have #{@card_count} cards totaling #{@hand}.",
      "Enter \'hit\' to hit", "Enter \'stand\' to stand")
  end

  def new
      case @card_count
      when 0
        first_card = Card.new
        second_card = Card.new
        dealer_card = Card.new
        @dealer_hand = dealer_card.value
        output_game_header("Your first card is the #{first_card.type} of #{$suits.sample}.",
        "Your second card is the #{second_card.type} of #{$suits.sample} ",
        "The dealer has the #{dealer_card.type} of #{$suits.sample} showing.")
        @hand = first_card.value
        @hand += second_card.value
        @card_count += 2
      else
        next_card = Card.new
        output_game_header("Your new card is the #{next_card.type} of #{$suits.sample}.")
        @hand += next_card.value
        @card_count += 1
      end
    @hand == 21 ? game_over : nil
    @hand > 21 ? game_over : decision
  end

  def win
    output_game_header("Congratulations! You Won!",
    "You had #{@hand}", "The dealer had #{@dealer_hand}")
  end

  def lose
    output_game_header("You lost. Better luck next time!",
    "You had #{@hand}", "The dealer had #{@dealer_hand}")
  end

  def quit
    output_game_header("Are you sure you want to quit (yes/no)?")
    answer = nil
    until ["yes", "no"].include?(answer)
    answer = gets.chomp
      if answer == "yes"
        output_game_header("Thanks for playing Blackjack!", "Goodbye!")
        return :quit
      elsif answer == "no"
        @card_count == 0 ? intro : decision
      else
        output_game_header("I'm sorry, I don't understand that command.","Enter \'yes\' to quit","Enter \'no\' to continue")
      end
    end
  end

  def game_over
    puts @dealer_hand
    @dealer_hand += (1 + rand(9))
    if @hand == 21 && @dealer_hand != 21
      win
    elsif @hand > 21
      lose
    elsif @hand > @dealer_hand
      win
    else
      nil
    end
    new_game
  end

  def new_game
    output_game_header("Would you like to play again?","Enter \'new game\' to restart")
  end

  def get_hand
    return @hand
  end
  def get_card_count
    return @card_count
  end
  def get_dealer_hand
    return @dealer_hand
  end
  def get_cash
    return @cash
  end
  def output_game_header(text, *more)
    print ">" * 60
    puts "\n\n#{text.center(60)}\n"
    more.each do |txt|
      puts "\n#{txt.center(60)}\n"
    end
    print "\n" + "<" * 60 + "\n"
  end
  def intro
    print ">" * 60 +"\n\n\n"
    puts "Welcome to Blackjack:".center(60)
    puts "Enter \'new\' to start a new game".center(60) + "\n" + "Enter \'quit\' to quit".center(60) + "\n\n\n"
    print "<" * 60 +"\n\n"
  end

end
