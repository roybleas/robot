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
			#puts "I am at #{@location.x},#{@location.y} facing #{@location.facing}"
			puts "#{@location.x},#{@location.y},#{@location.facing}"
		end
	end
end

class Location
	attr_accessor :x , :y, :facing
	
	
	def initialize(x = 0, y = 0, facing = 'NORTH')
		
		match = self.valid.match(x) if x.respond_to?(:to_str)
		if match.nil?
				@x = x
				@y = y
				@facing = facing
		else
			set_location(x)
		end
		
	end
	
	def valid
		return /^\d+,\d+,(NORTH|SOUTH|EAST|WEST)$/i
	end
	
	def facing= direction 
		if (direction =~ /^(NORTH|EAST|SOUTH|WEST)$/i).nil?
			raise(InvalidLocationInputError, "Invalid direction:#{direction}")
		else
			@facing = direction.upcase 
		end	
	end
	
	def set_location(location_str)
		components = location_str.split(",")
		@x = components[0].to_i
		@y = components[1].to_i
		@facing = components[2]
	end

	def values
		return "#{@x},#{@y},#{@facing}"
	end
	
	def ==(other)
		return false unless other.instance_of?(self.class)
		x == other.x && y == other.y && facing == other.facing
	end
end
class InvalidLocationInputError < StandardError; end

class Tablemap
	attr_accessor :size
	def initialize(length = 5)
		@size = length
	end
	
	def valid_location?(location)
		valid = false
		
		if location.x >= 0 and location.y >= 0
			if location.x < @size and  location.y < @size
				valid = true
			end
		end

		return valid
	end
end

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
		return !(location =~ Location.new.valid).nil?
	end
	
end



