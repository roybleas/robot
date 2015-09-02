require "spec_helper"
require '././lib/robot/location'

describe Location do
	describe "initialization" do
		it "sets default starting point" do
			loc = Location.new
			expect(loc.x).to eq(0)
			expect(loc.y).to eq(0)
			expect(loc.facing).to eq('NORTH')
		end
		it "sets initial input" do
			loc = Location.new(1,2,'SOUTH')
			expect(loc.x).to eq(1)
			expect(loc.y).to eq(2)
			expect(loc.facing).to eq('SOUTH')
		end
		it "extracts initial input" do
			loc = Location.new("3,4,WEST")
			expect(loc.x).to eq(3)
			expect(loc.y).to eq(4)
			expect(loc.facing).to eq('WEST')
		end			
		it "has classes with equality" do
			locA  = Location.new(1,2,'SOUTH')
			locB = Location.new('1,2,SOUTH')
			expect(locA == locB).to be_truthy
			expect(locB).to eq(locA)
		end
		it "rejects invalid initial location" do
			invalid_location = "1,WEST,2"
			expect {Location.new(invalid_location) }.to raise_error("Invalid initial direction:#{invalid_location}")
		end
	end
	
	context "valid facing values" do
		it "stores facing in uppercase" do
			loc = Location.new
			loc.facing = 'wesT'
			expect(loc.facing).to eq 'WEST'
		end
	end
	
	context "invalid facing values" do
		before(:each) do
			@loc = Location.new
		end
			
		it "ignores numbers" do
			expect { @loc.facing = 2 }.to raise_error("Invalid direction:#{2}")
			expect(@loc.facing).to eq('NORTH')
		end
		
		it "Rejects non compass direction" do
			%w[NotNorth Sith yeast Wes].each do |direction| 
				expect { @loc.facing = direction }.to raise_error("Invalid direction:#{direction}")
				expect(@loc.facing).to eq('NORTH')
			end
		end
	end
	
	context "reporting" do
		it "reports on its position" do
			loc = Location.new("0,1,WEST")
			expect(loc.values).to eq('0,1,WEST')
		end
	end
				
end

