class String
  # colours
  def colourise(colour_code)
    "\e[#{colour_code}m#{self}\e[0m"
  end

  def green
    colourise(32)
  end

  def yellow
    colourise(33)
  end

  def grey
    colourise(2)
  end

  def strikethrough
    colourise(9)
  end
end

class Game

  def initialize
    @word = $words.sample.upcase
    @incorrect = 0
    @board = []
    @grey_letters = []
    @yellow_letters = []
    @green_letters = []
  end

  def assess_word(w)
    x = 0
    word = Array(@word.each_char)
    w.each_char do |l|
      if l == @word[x]
        word.delete_at(word.index(l))
      end
      x += 1
    end
    x = 0
    w.each_char do |l|
      if l == @word[x]
        print l.green
        @yellow_letters.delete(l)
        @green_letters <<  l unless @green_letters.include?(l)
      elsif word.include? l
        print l.yellow
        word.delete_at(word.index(l))
        @yellow_letters << l unless @yellow_letters.include?(l)
      else
        print l
        @grey_letters << l unless @grey_letters.include?(l)
      end
      x += 1
    end
  end

  def show_board
    logo
    y = 1
    @board.each do |w|
      print "#{y}: "
      assess_word(w)
      print "\n"
      y += 1
    end
    puts if y > 1
    $alphabet.each do |a|
      if @green_letters.include?(a)
        print "#{a.green}  "
      elsif @yellow_letters.include?(a)
        print "#{a.yellow}  "
      elsif @grey_letters.include?(a)
        print "#{a.grey.strikethrough}  "
      else
        print "#{a}  "
      end
    end
    puts "\n\n"
  end

  def win
    $score += 1
    show_board
    puts "Congratulations, you win! You've won #{$score} games. Play again? (y/n)"
    response = gets.chomp
    if response.downcase == "y"
      $game = Game.new
      $game.play
    elsif response.downcase == "n"
      puts "\nThank you for playing! Goodbye!"
      sleep(1.5)
      system "clear"
      exit
    else
      system "clear"
      win
    end
  end

  def lose
    show_board
    puts "Sorry, you lose. The word was #{@word}. Play again? (y/n)"
    response = gets.chomp
    if response.downcase == "y"
      $game = Game.new
      $game.play
    elsif response.downcase == "n"
      puts "\nThank you for playing! Goodbye!"
      sleep(1.5)
      system "clear"
      exit
    else
      system "clear"
      lose
    end
  end

  def lettersonly(str)
    if str =~ /[A-Z]{5}/ 
      true
    else
      false
    end
  end

  def guess
    show_board
    print "Enter a 5 letter word: "
    entry = gets.chomp
    entry.upcase!
    unless entry.size == 5 && lettersonly(entry)
      puts "Please enter a 5 letter word!"
      sleep(1.5)
    else
      @board << entry
      if entry == @word
        system "clear"
        win
      else
        @incorrect += 1
      end
    end
  end

  def play
    until @incorrect == 6
      system "clear"
      guess
    end
    system "clear"
    lose
  end

end

def logo
  puts "   ____   __    __   ______     ______     _____        _____  
  / ___)  ) )  ( (  (   __ \\   (_  __ \\   (_   _)      / ___/  
 / /     ( (    ) )  ) (__) )    ) ) \\ \\    | |       ( (__    
( (       ) )  ( (  (    __/    ( (   ) )   | |        ) __)   
( (      ( (    ) )  ) \\ \\  _    ) )  ) )   | |   __  ( (      
 \\ \\___   ) \\__/ (  ( ( \\ \\_))  / /__/ /  __| |___) )  \\ \\___  
  \\____)  \\______/   )_) \\__/  (______/   \\________/    \\____\\ 
                                                               \n\n"
end

if __FILE__ == $0
  system "clear"
  logo
  sleep(2)
  $words = []
  $alphabet = ["Q","W","E","R","T","Y","U","I","O","P","\n",
    "A","S","D","F","G","H","J","K","L","\n",
    "","Z","X","C","V","B","N","M"]
  File.open("words.txt").each_line do |line| 
    $words << line.split("\n")[0]
  end
  $score = 0
  $game = Game.new
  $game.play
end
