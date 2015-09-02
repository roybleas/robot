require "spec_helper"
require '././lib/robot/robot'

describe Robot do
	context "initialization" do
		it "creates a toy robot" do
			table = Tablemap.new
			bot = Robot.new(table)
			expect(bot).to be_a(Robot)
		end
	end
	
	context "feed instructions" do
		before(:each) do
			table = Tablemap.new
			@bot = Robot.new(table)
		end
		
		context "placement" do
			it "places the robot" do
				instruction = Instruction.new(:place)
				instruction.location = Location.new(0,0,"NORTH")
				@bot.feed(instruction)
				expect(@bot.location).to_not be_nil
				expect(@bot.location.x).to eq(0)
				expect(@bot.location.y).to eq(0)
				expect(@bot.location.facing).to eq("NORTH")
			end
			context "fails to act without placement" do
				it "does not move before placement" do
					instruction = Instruction.new(:move)
					@bot.feed(instruction)
					expect(@bot.location).to be_nil
					expect{@bot.report}.to output("Not yet placed\n").to_stdout 
				end
				it "does not turn before placement" do
					instruction = Instruction.new(:left)
					@bot.feed(instruction)
					expect(@bot.location).to be_nil
					expect{@bot.report}.to output("Not yet placed\n").to_stdout 

					instruction = Instruction.new(:right)
					@bot.feed(instruction)
					expect(@bot.location).to be_nil
					expect{@bot.report}.to output("Not yet placed\n").to_stdout 
				end

			end
		end		
		context "turning" do
			before(:each) do
				@instruction = Instruction.new(:place)
				@instruction.location = Location.new(0,0,"NORTH")
				@bot.feed(@instruction)
			end
			
			it "will face west after turning left from North" do
				instruction = Instruction.new(:left)
				@bot.feed(instruction)
				expect(@bot.location.facing).to eq("WEST")
			end
			
			it "will face east after turning right from North" do
				instruction = Instruction.new(:right)
				@bot.feed(instruction)
				expect(@bot.location.facing).to eq("EAST")
			end
			
			it "will face south after turning left from West" do
				@bot.location.facing = "WEST"
				instruction = Instruction.new(:left)
				@bot.feed(instruction)
				expect(@bot.location.facing).to eq("SOUTH")
			end
			
			it "will face south after turning right from East" do
				@bot.location.facing = "East"
				instruction = Instruction.new(:right)
				@bot.feed(instruction)
				expect(@bot.location.facing).to eq("SOUTH")
			end

			it "will face north after turning left from East" do
				@bot.location.facing = "East"
				instruction = Instruction.new(:left)
				@bot.feed(instruction)
				expect(@bot.location.facing).to eq("NORTH")
			end
			
			it "will face north after turning right from west" do
				@bot.location.facing = "West"
				instruction = Instruction.new(:right)
				@bot.feed(instruction)
				expect(@bot.location.facing).to eq("NORTH")
			end
		end
		
		context "move to a valid" do
			before(:each) do
				@instruction = Instruction.new(:place)
				@instruction.location = Location.new(0,0,"NORTH")
				@bot.feed(@instruction)
			end
			
			it "northen location" do
				instruction = Instruction.new(:move)
				@bot.feed(instruction)
				expect(@bot.location.facing).to eq("NORTH")
				expect(@bot.location.x).to eq(0)
				expect(@bot.location.y).to eq(1)
			end
			it "eastern location" do
				@bot.location.facing = "East"
				instruction = Instruction.new(:move)
				@bot.feed(instruction)
				expect(@bot.location.facing).to eq("EAST")
				expect(@bot.location.x).to eq(1)
				expect(@bot.location.y).to eq(0)
			end

			it "southern location" do
				@instruction.location = Location.new(4,4,"SOUTH")
				@bot.feed(@instruction)
				instruction = Instruction.new(:move)
				@bot.feed(instruction)
				expect(@bot.location.facing).to eq("SOUTH")
				expect(@bot.location.x).to eq(4)
				expect(@bot.location.y).to eq(3)
			end
			it "western location" do
				@instruction.location = Location.new(4,4,"WEST")
				@bot.feed(@instruction)
				instruction = Instruction.new(:move)
				@bot.feed(instruction)
				expect(@bot.location.facing).to eq("WEST")
				expect(@bot.location.x).to eq(3)
				expect(@bot.location.y).to eq(4)
			end
		end
		context "ignore invalid move" do
			before(:each) do
				@instruction = Instruction.new(:place)
				@instruction.location = Location.new(4,4,"NORTH")
				@bot.feed(@instruction)
			end
			
			it "northern location" do
				instruction = Instruction.new(:move)
				@bot.feed(instruction)
				
				expect(@bot.location.facing).to eq("NORTH")
				expect(@bot.location.x).to eq(4)
				expect(@bot.location.y).to eq(4)
			end
			it "eastern location" do
				@bot.location.facing = "EAST"
				instruction = Instruction.new(:move)
				@bot.feed(instruction)
				expect(@bot.location.facing).to eq("EAST")
				expect(@bot.location.x).to eq(4)
				expect(@bot.location.y).to eq(4)
			end
			it "western location" do
				@bot.location.facing = "West"
				@bot.location.x = 0
				instruction = Instruction.new(:move)
				@bot.feed(instruction)
				expect(@bot.location.facing).to eq("WEST")
				expect(@bot.location.x).to eq(0)
				expect(@bot.location.y).to eq(4)
			end
			it "southtern location" do
				@bot.location.facing = "SOUTH"
				@bot.location.y = 0
				instruction = Instruction.new(:move)
				@bot.feed(instruction)
				expect(@bot.location.facing).to eq("SOUTH")
				expect(@bot.location.x).to eq(4)
				expect(@bot.location.y).to eq(0)
			end
		end
		context "reporting" do
			it "reports a valid location" do
				instruction = Instruction.new(:place)
				instruction.location = Location.new(1,2,"EAST")
				@bot.feed(instruction)
				expect{@bot.report}.to output("1,2,EAST\n").to_stdout 
			end
		end
	end
end