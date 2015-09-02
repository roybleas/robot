class Location
	attr_accessor :x , :y, :facing
		
	def initialize(x = 0, y = 0, facing = 'NORTH')
		
		if x.respond_to?(:to_str)
			if self.valid_instruction?(x)
				set_location(x)
			else
				raise(InvalidLocationInputError, "Invalid initial direction:#{x}")
			end
		else
			@x = x
			@y = y
			@facing = facing
		end
		
	end
	
	def valid_instruction?(instruction)
		location_regex_pattern = /^\d+,\d+,(NORTH|SOUTH|EAST|WEST)$/i
		return !(location_regex_pattern.match(instruction)).nil?
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
