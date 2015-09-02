require_relative 'tablemap'
require_relative 'instructions'
require_relative 'location'

class Robot
  attr_reader :location
  
  def initialize(table)
    @map = table
    @compass_points = %w[ NORTH EAST SOUTH WEST NORTH]
  end
  
  def feed(instruction)
  
    case instruction.action
    when :place 
      place(instruction.location)
      
    when :move   
      move_forward unless @location.nil?
      
    when :left  
      turn_left unless @location.nil?
      
    when :right 
      turn_right unless @location.nil?
      
    when :report
      report 
    end

  end
  
  def place(location)
    @location = location.dup if @map.valid_location?(location)
  end
  
  def move_forward
    new_location = @location.dup
    case @location.facing
    when "NORTH"
      new_location.y += 1
    when "SOUTH"
      new_location.y -= 1
    when "EAST"
      new_location.x += 1
    when "WEST"
      new_location.x -= 1
    end

    if @map.valid_location?(new_location)
      @location = new_location
    end
  end

  def turn_left
    @location.facing = @compass_points[ @compass_points.rindex(@location.facing) - 1]
  end
  
  def turn_right 
    @location.facing = @compass_points[ @compass_points.index(@location.facing) + 1]
  end
  
  def report
    if @location.nil?
      puts "Not yet placed"
    else
      puts "#{@location.x},#{@location.y},#{@location.facing}"
    end
  end
end
