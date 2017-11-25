#! /bin/ruby

class BitClock

  # how to fill the letters
  $full = "▮"
  # hard-coded digits for display
  $nums = {
    "0" => [1,0,1,1,1,1,1],
    "1" => [0,0,0,0,1,0,1],
    "2" => [1,1,1,0,1,1,0],
    "3" => [1,1,1,0,1,0,1],
    "4" => [0,1,0,1,1,0,1],
    "5" => [1,1,1,1,0,0,1],
    "6" => [1,1,1,1,0,1,1],
    "7" => [1,0,0,0,1,0,1],
    "8" => [1,1,1,1,1,1,1],
    "9" => [1,1,1,1,1,0,1],
  }

  # to fix: detect if under ruby console
  begin
    $catch = IRB::Abort
  rescue
    $catch = Interrupt
  end

  # check if user wants to quit ('q' key does not work)
  def self.quit?
    begin
      while c = STDIN.read_nonblock(1)
        return true if 'qQ'.split.include? c
      end
      false
    rescue Errno::EINTR
      false
    rescue Errno::EAGAIN
      false
    rescue EOFError
      true
    end
  end

  def self.calc_constants
    ($height, $width) = `stty size`.split(/\s/).map(&:to_i)
    colpos = [39,33,27]
    colpos = [39] if $height / $width.to_f < 0.1282
    i = 0
    $cols = 0

    colpos.each {|i| $cols = i; break if i < $width}
    $coef = $width / $cols
    rest = $width % $cols
    $frnt = (rest/2.0).ceil
    $back = $width - $cols*$coef - $frnt
    $coev = ($coef/2.0).ceil

    while ($coev > $height)
      if i < colpos.length - 1
        $cols = colpos[i]
        i += 1
        $coef = $width / $cols
        rest = $width % $cols
      else
        $coef -= 1
        rest = $width - $cols * $coef
      end
      $coev = ($coef/2.0).ceil
      $frnt = (rest/2.0).ceil
      $back = $width - $cols*$coef - $frnt
    end

    $top = ($height - $coev * 5) / 2
    $bottom = $height - $top - (5*$coev) - 2
    $ltrs = ($cols - 9) / 6
  end

  def self.calc_pix num, line
    ltr = $nums[num]
    rel = [[0,3,3,4,4],[nil,3,3,4,4],[1,3,5,4,6],[nil,5,5,6,6],[2,5,5,6,6]]
    out = []
    $ltrs.times {out << " "}
    #$full = num.to_s
    rel[line].each_with_index do |r,i|
      next unless r
      if ltr[r] == 1 and i == 0
        out.map! {$full}
        break
      elsif ltr[r] == 1 and i < 3
        out[0] = $full
      elsif ltr[r] == 1
        out[-1] = $full
      end
    end
    return out
  end

  def self.print_clock time, pts
    puts "\e[H\e[2J"
    tarr = time.strftime("%H:%M:%S").split(":")
    lines = []
    5.times do |i|
      row = ""
      tarr.each_with_index do |num,ind|
        clr = $clr[ind]
        BitClock.calc_pix(num[0],i).each {|pix| row += "#{clr}#{pix * $coef}\e[0m"}
        row += " " * $coef
        BitClock.calc_pix(num[1],i).each {|pix| row += "#{clr}#{pix * $coef}\e[0m"}
        break if ind == 2
        row += " " * $coef
        if pts and [1,3].include?(i)
          row += "\e[1m\e[30m#{($full * $coef)}\e[0m"
        else
          row += " " * $coef
        end
        row += " " * $coef
      end
      lines[i] = ""
      $frnt.times {lines[i] += " "}
      lines[i] += row
      $back.times {lines[i] += " "}
    end
    $top.times {print " "*$width}
    5.times {|i| $coev.times {print lines[i]}}
    $bottom.times {print " "*$width}
    print " "*($width-2)
  end

  def self.run argv
    td = argv.grep(Float)
    argv -= td
    td = td.any? ? (td.first * 60 * 60) : 0
    case argv.length
    when 3
      $clr = argv
    when 2
      $clr = [argv[0],argv[0],argv[1]]
    when 1
      $clr = [argv[0],argv[0],argv[0]]
    else
      $clr = ["\e[0m\e37m", "\e[0m\e37m", "\e[0m\e37m"]
    end
    while Time.now.strftime("%L").to_i < 999
    end
    BitClock.calc_constants
    sleep 0.35
    pts = -1
    loop do
      if BitClock.quit?
        print "\r"+" "*$width
        break
      end
      begin
        sleep 0.5
        BitClock.print_clock (Time.now + td), [false,true][(pts+1)/2]
        pts *= -1
      rescue $catch
        print "\r"+" "*$width
        break
      end
      BitClock.calc_constants unless "#{$height} #{$width}\n" == `stty size`
    end
  end

  colors = { "black" => "\e[1m\e[30m",
             "red" => "\e[1m\e[31m",
             "green" => "\e[1m\e[32m",
             "yellow" => "\e[1m\e[33m",
             "blue" => "\e[1m\e[34m",
             "magenta" => "\e[1m\e[35m",
             "cyan" => "\e[1m\e[36m",
             "white" => "\e[1m\e[37m",
             "default" => "\e[0m\e[37m",
             "dark-red" => "\e[0m\e[31m",
             "dark-green" => "\e[0m\e[32m",
             "dark-yellow" => "\e[0m\e[33m",
             "dark-blue" => "\e[0m\e[34m",
             "dark-magenta" => "\e[0m\e[35m",
             "dark-cyan" => "\e[0m\e[36m",
             "dark-white" => "\e[0m\e[37m",
            }
  BitClock.run ARGV.map{|arg| colors.keys.include?(arg) ? colors[arg] : (arg.match(/^[+-]?\d[\d\.,]*$/) ? arg.to_f : colors["default"])} if $catch == Interrupt
end
