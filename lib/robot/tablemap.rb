class Tablemap
	
	attr_accessor :x,:y
	
	def initialize(*p)
		if p.size == 1
			@x = p[0]
			@y = p[0]
		elsif p.size == 2
			@x = p[0]
			@y = p[1]
		else
			@x = 5
			@y = 5
		end
		
	end
	
	def valid_location?(location)
		valid = false
		
		if location.x >= 0 and location.y >= 0
			if location.x < @x and  location.y < @y
				valid = true
			end
		end

		return valid
	end
end
