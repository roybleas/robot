require "spec_helper"
require '././robot'

describe Location do
	describe "initialization" do
		it "sets default starting point" do
			loc = Location.new
			expect(loc.x).to eq(0)
			expect(loc.y).to eq(0)
			expect(loc.facing).to eq('N')
		end
		it "sets initial input" do
			loc = Location.new(1,2,'S')
			expect(loc.x).to eq(1)
			expect(loc.y).to eq(2)
			expect(loc.facing).to eq('S')
		end
	end
	
	context "valid facing values" do
		it "stores facing in uppercase" do
			loc = Location.new
			loc.facing = 'w'
			expect(loc.facing).to eq 'W'
		end
	end
	
	context "invalid facing values" do
		before(:each) do
			@loc = Location.new
		end
			
		it "ignores numbers" do
			expect { @loc.facing = 2 }.to raise_error("Invalid direction:#{2}")
			expect(@loc.facing).to eq('N')
		end
		
		it "ignores all letters except NSEW" do
			([*('A'..'Z')] - %w[N S E W]).each do |direction| 
				expect { @loc.facing = direction }.to raise_error("Invalid direction:#{direction}")
				expect(@loc.facing).to eq('N')
			end
		end
	end
				
end

