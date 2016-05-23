require 'game'

class Score

  @@filepath = nil

  def initialize(args={})
    @name = args[:name]      || ""
    @cash = args[:cash]      || 10000
  end

  def self.filepath=(path=nil)
    @@filepath = File.join(APP_ROOT, path)
  end

  def self.file_exists?
    @@filepath && File.exists?(@@filepath) ? true : false
  end

  def self.file_usable?
    return false unless @@filepath
    return false unless File.exists?(@@filepath)
    return false unless File.readable?(@@filepath)
    return false unless File.writable?(@@filepath)
    return true
  end

  def self.create_file
    File.open(@@filepath, 'w') unless file_exists?
    return file_usable?
  end

  def self.high_scores
    high_scores = []
    if file_usable?
      file = File.new(@@filepath, 'r')
      file.each_line do |line|
        line_array = line.chomp.split(/\t/)
        @name, @cash = line_array
        high_scores << {:name => @name, :cash => @cash}
      end
      file.close
    end
    sorted = high_scores.sort { |h1, h2| h2[:cash].to_i <=> h1[:cash].to_i }
    return sorted
  end

  def self.score_exists?(name)
    names = Score.high_scores.to_s
    names.include?(name) ? true : false
  end

  def self.save(score)
    return false unless Score.file_usable?
    File.open(@@filepath, 'a') do |file|
      file.puts "#{[score[:name], score[:cash]].join("\t")}\n"
    end
    return true
  end

end
