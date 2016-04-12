#variables, arrays, and hashes
$cards = {1 => 'Ace', 2 => 'Two', 3 => 'Three', 4 => 'Four', 5 => 'Five', 6 => 'Six',
  7 => 'Seven', 8 => 'Eight', 9 => 'Nine', 10 => 'Ten', 11 => 'Jack', 12 => 'Queen', 13 => 'King'}
suits = ['Diamonds', 'Hearts', 'Spades', 'Clubs']
$values = {'Ace' => 1, 'Two' => 2, 'Three' => 3, 'Four' => 4, 'Five' => 5, 'Six' => 6,
  'Seven' => 7, 'Eight' => 8, 'Nine' => 9, 'Ten' => 10, 'Jack' => 10, 'Queen' => 10, 'King' => 10 }
@hand = 0
@card_count = 0
@dealer_hand = nil

#Classes
class Card
  def initialize
    @type = $cards[1 + rand(12)]
    @value = $values[@type]
  end
  def type
    return @type
  end
  def value
    return @value
  end
end
class Dealer
  def initialize
    @dealer_hand = (1 + rand(9))
    @dealer_type = $cards[@dealer_hand]
  end
  def hand
    return @dealer_hand
  end
  def type
    return @dealer_type
  end
end

#Executable code first card
while @card_count < 1
puts "Blackjack:
      Enter \'1\' for card
      Enter \'q\' to quit "
print ">"
a = gets.chomp

if a == "1"
  first_card = Card.new
  dealer_card = Dealer.new
  @hand += first_card.value
  @card_count += 1
  puts "Your first card is the #{first_card.type} of #{suits.sample}."
  puts "The dealer has the #{dealer_card.type} of #{suits.sample} showing."
elsif a == "q"
  puts "Goodbye"
  exit
else
  nil
end

#Second Card and beyond
while @hand < 21 && @end != true
puts "You have #{@card_count} card(s) totaling #{@hand}
      Enter \'1\' to hit
      Enter \'2\' to stand"
print ">"
a = gets.chomp

@hand == 21 ? @end == true : nil

if a == "1"
  second_card = Card.new
  @hand += second_card.value
  @card_count += 1
  puts "Your second card is the #{second_card.type} of #{suits.sample}."
elsif a == "2"
  @end = true
  break
else
  nil
end

puts @dealer_hand
end
puts "You have #{@card_count} cards with a total of #{@hand}"
if @hand == 21
  puts "Congratulations, you got 21!"
else
  puts "Better luck next time"
end
end
