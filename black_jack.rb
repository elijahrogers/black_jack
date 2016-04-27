APP_ROOT = File.dirname(__FILE__)
$:.unshift( File.join(APP_ROOT, 'lib'))
require "#{APP_ROOT}/lib/game"

$game = Game.new('high_scores.txt')
$game.launch!
