class Toyrobot

  def initialize
    @size = 4
    @x = nil
    @y = nil
    @f = nil
    @compass_points = %w[ NORTH EAST SOUTH WEST NORTH]
  end
  
  def report
    if @x.nil? || @y.nil? || @f.nil? 
      puts "unknown"
    else
      puts "#{@x},#{@y},#{@f}"
    end
  end
  
  def feed(line)
    line = line.strip.chomp
    
    case line
    when /^PLACE\s\d+,\d+,(NORTH|SOUTH|EAST|WEST)$/i
      place_me(line)
    when /^LEFT$/i
      turn_left unless @f.nil?
    when /^RIGHT$/i
      turn_right unless @f.nil?
    when /^MOVE$/i
      move_forward
    when /^REPORT$/i
      report
    end
    
  end
  
  def place_me(line)
  
    location_str =  line.slice(6..-1)
    components = location_str.split(",")
    x = components[0].to_i
    y = components[1].to_i
    f = components[2]
    
    if (x <= @size && x >= 0 ) && (y <= @size && y >= 0 ) 
      @x = x
      @y = y
      @f = f.upcase
    end
  end
  
  def turn_left
    @f = @compass_points[ @compass_points.rindex(@f) - 1]
  end
  
  def turn_right 
    @f = @compass_points[ @compass_points.index(@f) + 1]
  end

  def move_forward
    unless @f.nil?
      case @f
      when "EAST"
        @x += 1 unless @x > 3
      when "WEST"
        @x -= 1 unless @x < 1
      when "NORTH"
        @y += 1 unless @y > 3
      when "SOUTH"
        @y -= 1 unless @y < 1
      end
    end 
  end
end