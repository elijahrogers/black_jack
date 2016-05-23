require 'card'
class Hand

  attr_reader :value, :cards, :card_count
  def initialize
    @first_card = Card.new
    @second_card = Card.new
    @cards = [@first_card, @second_card]
    @value = @first_card.value
    @value += @second_card.value
    @card_count = 2
    @over = false
  end

  def is_over?
    @over
  end

  def over
    @over = true
  end

  def update
    @value = 0
    @cards.each do |card|
      @value += card.value
    end
  end

  def new_card
    new = Card.new
    @cards << new
    @value += new.value
    @card_count += 1
    return new
  end


end
