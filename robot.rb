
class Location
	attr_accessor :x , :y, :facing
	
	def initialize(x = 0, y = 0, facing = 'N')
		@x = x
		@y = y
		@facing = facing
	end
	
	def facing= direction 
		if (direction =~ /^(N|E|S|W)$/i).nil?
			raise(InvalidLocationInputError, "Invalid direction:#{direction}")
		else
			@facing = direction.upcase 
		end	
	end
	
end

class InvalidLocationInputError < StandardError; end