require 'card'


#Classes
class Game
  class Config
    @@actions = ['new', 'quit']
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
      until @over == true do
        decision
      end
      if @hand == 21 && @dealer_hand != 21
        win
      elsif @hand > @dealer_hand && @hand <= 21
        win
      else
        lose
      end
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
      new
    when "quit"
      return :quit
    end
  end

  def decision
    until @hand >= 21 || @over == true
      output_game_header("You have #{@card_count} cards totaling #{@hand}.",
      "Enter \'hit\' to hit", "Enter \'stand\' to stand")
      dec = gets.downcase.chomp
      case dec
      when "hit"
        game_action("new")
      when "stand"
        @over = true
      else
        redo
      end
    end
    @dealer_hand += Card.new.value
    @over = true
  end

  def new
    case @card_count
    when 0
      first_card = Card.new
      second_card = Card.new
      @hand = first_card.value
      @hand += second_card.value
      @card_count += 2
      dealer_card = Card.new
      @dealer_hand = dealer_card.value
      output_game_header("Your first card is the #{first_card.type} of #{$suits.sample}.",
      "Your second card is the #{second_card.type} of #{$suits.sample} ",
      "The dealer has the #{dealer_card.type} of #{$suits.sample} showing.")
    else
      next_card = Card.new
      @hand += next_card.value
      @card_count += 1
      output_game_header("Your new card is the #{next_card.type} of #{$suits.sample}.")
    end
  end

  def win
    output_game_header("Congratulations! You Won!",
    "You had #{@hand}", "The dealer had #{@dealer_hand}")
  end

  def lose
    output_game_header("You lost. Better luck next time!",
    "You had #{@hand}", "The dealer had #{@dealer_hand}")
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
=begin

=end
