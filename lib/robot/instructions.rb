class Instruction
  attr_accessor :action, :location
  
  def initialize(action)
    @action = action
  end
  
  def location= (location)
    @location = location.dup
  end
  
  def ==(other)
    return false unless other.instance_of?(self.class)
    action == other.action && location == other.location
  end
end 

class Instructions
  attr_reader :instruction_set
  
  def initialize
    @instruction_set = []
  end
  
  def extract_instructions(line)
    line.strip.chomp!
    if not /^\s*#/ =~ line
      instructions = line.split
      instructions.each do |instruction|
        
        add_location_to_previous_place_instruction(instruction)
        
        if is_valid_action?(instruction)
          @instruction_set << Instruction.new(instruction.downcase.to_sym)    
          remove_place_instruction_if_final(instruction,instructions)
        end 
      end
    end     
  end
  
  def add_location_to_previous_place_instruction(instruction)
    unless @instruction_set.empty?
      last_instruction = @instruction_set.last
      if last_instruction.action == :place 
        if is_valid_location?(instruction)
          last_instruction.location = Location.new(instruction)
        else
          if last_instruction.location.nil?
            @instruction_set.pop
          end
        end
      end
    end
  end
  
  def remove_place_instruction_if_final(instruction,in_instructions)
    if @instruction_set.last.action == :place
      if instruction == in_instructions.last
        @instruction_set.pop
      end
    end
  end
  
  def is_valid_action?(action)
    return !(action =~ /^(PLACE|MOVE|LEFT|RIGHT|REPORT)$/i).nil?
  end
  
  def is_valid_location?(location)
    return Location.new.valid_instruction?(location)
  end
  
end



