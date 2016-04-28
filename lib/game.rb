require 'card'
require 'score'
require 'hand'

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

    def self.winsize
      require 'io/console'
      IO.console.winsize
    end
  end

  def initialize(path=nil)
    @winsize = Config.winsize[1]
    Score.filepath = path
    Score.file_usable? ? nil : Score.create_file
    @dealer_hand = 0
    @cash = 10000
    @name = nil
    @payout = 0
    @hand = nil
  end

  def launch!
    logo_text
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
    if @hand == nil
      case action
      when "new"
        new
      when "quit"
        quit
      when "high scores"
        scores = Score.high_scores
        output_high_scores(scores)
      end
    elsif @hand != nil && @hand.is_over?
        case action
        when "again"
          @payout != 0
          @dealer_hand = 0
          @bet = 0
          @payout = 0
          @hand = nil
          @game_over = false
          new
        when "high scores"
          scores = Score.high_scores
          output_high_scores(scores)
        when "quit"
          quit
        end
    else
      case action
      when "quit"
        quit
      when "hit"
        new
      when "stand"
        game_over
      when "high scores"
        scores = Score.high_scores
        output_high_scores(scores)
      end
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
      output_game_header("You have #{@hand.card_count} cards totaling #{@hand.value}.",
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
      if @hand == nil
        bet
        @hand = Hand.new
        output_cards(@hand.cards)
        dealer_card = Card.new
        @dealer_hand = dealer_card.value
        output_game_header("Your first card is the #{@hand.cards[0].type} of #{@hand.cards[0].suit}.",
        "Your second card is the #{@hand.cards[1].type} of #{@hand.cards[1].suit} ",
        "The dealer has the #{dealer_card.type} of #{dealer_card.suit} showing.")
      else
        @hand.new_card
        output_cards(@hand.cards)
        output_game_header("Your new card is the #{@hand.cards[-1].type} of #{@hand.cards[-1].suit}.")
      end
    @hand.value >= 21 ? game_over : decision
  end

  def win
    output_game_header("Congratulations #{@name.capitalize_each}! You Won!",
    "You had #{@hand.value}", "The dealer had #{@dealer_hand}", "You bet $#{@bet}, and you won $#{@payout}")
  end

  def lose
    output_game_header("You lost. Better luck next time #{@name.capitalize_each}!",
    "You had #{@hand.value}", "The dealer had #{@dealer_hand}","You bet $#{@bet}, and you lost $#{@payout}")
    @cash <= 0 ? game_over : nil
  end

  def push
    output_game_header("Push!", "You had #{@hand.value}", "The dealer had #{@dealer_hand}")
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
        if @hand == nil && @name == nil
          intro
        else
          @hand == nil ? bet : nil
          !@hand.is_over? ? decision : new_game
        end
      else
        output_game_header("I'm sorry, I don't understand that command.","Enter \'yes\' to quit","Enter \'no\' to continue")
      end
    end
  end

  def game_over
    @hand.over
    if @cash <= 0
      output_game_header("Looks like you ran out of cash!", "Game over")
      exit!
    else
      nil
    end
    until @dealer_hand >= 17
      @dealer_hand += (1 + rand(9))
    end
    if @hand.value == 21 && @dealer_hand != 21
      @payout = (@bet * 1.5).to_i
      @cash += @payout
      win
    elsif @hand.value > 21
      @payout = @bet
      @cash -= @payout
      lose
    elsif @dealer_hand > 21
      @payout = @bet
      @cash += @payout
      win
    elsif @hand.value > @dealer_hand
      @payout = @bet
      @cash += @payout
      win
    elsif @hand.value < @dealer_hand
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
    print ">" * @winsize
    puts "\n\n#{text.center(@winsize)}\n"
    more.each do |txt|
      puts "\n#{txt.center(@winsize)}\n"
    end
    print "\n" + "<" * @winsize + "\n"
  end

  def output_cards(cards)
    print ">" * @winsize
    hand = ""
      @i = 0
      while @i < 9
        n = cards.size * 11
        hand << " " * ((@winsize - n) / 2)
        cards.each do |c|
        hand << c.output_card[@i]
        hand << " "
        end
        hand << "\n"
        @i += 1
      end
    print hand
    print "\n" + "<" * @winsize + "\n"
  end

  def output_high_scores(high_scores=[])
    print ">" * @winsize + "\n\n"
    print "Top 10 Blackjack Scores:".center(@winsize) +"\n\n"
    print "   " + "Name:".ljust(40)
    print " " + "Winnings:\n"
    print "." * @winsize + "\n\n"
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
    print "\n" + "<" * @winsize + "\n"
  end

  def intro
    print ">" * @winsize +"\n\n\n"
    puts "Welcome to Blackjack:".center(@winsize) + "\n\n"
    puts "Enter \'new\' to start a new game".center(@winsize) + "\n\n" +  "Enter \'high scores\' to see high scores".center(@winsize) + "\n\n" + "Enter \'quit\' to quit".center(@winsize) + "\n\n\n"
    print "<" * @winsize +"\n\n"
  end

  def outro
    output_game_header("Thanks for playing Blackjack!", "Goodbye!")
  end

  def logo_text
    print "\n\n\n"
    text = '
     /$$$$$$$  /$$                     /$$                /$$$$$                    /$$
    | $$__  $$| $$                    | $$               |__  $$                   | $$
    | $$  \ $$| $$  /$$$$$$   /$$$$$$$| $$   /$$            | $$ /$$$$$$   /$$$$$$$| $$   /$$
    | $$$$$$$ | $$ |____  $$ /$$_____/| $$  /$$/            | $$|____  $$ /$$_____/| $$  /$$/
    | $$__  $$| $$  /$$$$$$$| $$      | $$$$$$/        /$$  | $$ /$$$$$$$| $$      | $$$$$$/
    | $$  \ $$| $$ /$$__  $$| $$      | $$_  $$       | $$  | $$/$$__  $$| $$      | $$_  $$
    | $$$$$$$/| $$|  $$$$$$$|  $$$$$$$| $$ \  $$      |  $$$$$$/  $$$$$$$|  $$$$$$$| $$ \  $$
    |_______/ |__/ \_______/ \_______/|__/  \__/       \______/ \_______/ \_______/|__/  \__/
    '
    line = ""
    text.each_line do |l|
    line << " " * ((@winsize - 90) / 2)
    line << l
    end
    print line
    print "\n\n\n"
  end

end
