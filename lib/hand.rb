require 'card'
class Hand

  def initialize
    @first_card = Card.new
    @second_card = Card.new
    @cards = [@first_card, @second_card]
    @value = @first_card.value
    @value += @second_card.value
    @card_count = 2
    @over = false
  end

  def value
    return @value
  end

  def cards
    return @cards
  end

  def card_count
    return @card_count
  end

  def is_over?
    return @over
  end

  def over
    @over = true
  end

  def new_card
    new = Card.new
    @cards << new
    @value += new.value
    @card_count += 1
    return new
  end


end
