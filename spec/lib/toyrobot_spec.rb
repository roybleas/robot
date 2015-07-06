require "spec_helper"
require '././toyrobot'

describe Toyrobot do
	context "initialization" do
		it "creates a toy robot" do
			bot = Toyrobot.new()
			expect(bot).to be_a(Toyrobot)
		end
	end
	
	context "reports location" do
		before(:each) do
			@bot = Toyrobot.new
		end
		it "unknown when not placed" do
			@bot = Toyrobot.new
			expect{@bot.report}.to output("unknown\n").to_stdout 
		end
		
		it "when placed" do
			line = "PLACE 0,0,NORTH"
			@bot.feed(line)
			expect{@bot.report}.to output("0,0,NORTH\n").to_stdout 
		end
	end
	context "instruction" do
		before(:each) do
			@bot = Toyrobot.new
		end
		context "Place" do
			it "ignores an invalid instruction" do
				line = "PLAC"
				@bot.feed(line)
				expect{@bot.report}.to output("unknown\n").to_stdout 
			end
			it "set initial location" do
				line = "PLACE 0,1,NORTH"
				@bot.feed(line)
				expect{@bot.report}.to output("0,1,NORTH\n").to_stdout 
			end
			it "uses a facing of South" do
				line = "PLACE 0,1,South"
				@bot.feed(line)
				expect{@bot.report}.to output("0,1,SOUTH\n").to_stdout 
			end
			it "uses a facing of East" do
				line = "PLACE 0,1,EAST"
				@bot.feed(line)
				expect{@bot.report}.to output("0,1,EAST\n").to_stdout 
			end			
			it "uses a facing of West" do
				line = "PLACE 0,1,WEST"
				@bot.feed(line)
				expect{@bot.report}.to output("0,1,WEST\n").to_stdout 
			end
			it "rejects invalid facing of NORTHEAST" do
				line = "PLACE 0,1,NORTHWEST"
				@bot.feed(line)
				expect{@bot.report}.to output("unknown\n").to_stdout 
			end
			it "ignores an invalid X coordinate > 4" do
				line = "PLACE 5,1,WEST"
				@bot.feed(line)
				expect{@bot.report}.to output("unknown\n").to_stdout  
			end
			it "ignores an invalid Y coordinate > 4" do
				line = "PLACE 1,5,WEST"
				@bot.feed(line)
				expect{@bot.report}.to output("unknown\n").to_stdout  
			end
			it "ignores a command missing a comma" do
				line = "PLACE 1,0WEST"
				@bot.feed(line)
				expect{@bot.report}.to output("unknown\n").to_stdout  
			end
			it "ignores a command with extra a comma" do
				line = "PLACE ,1,0,WEST"
				@bot.feed(line)
				expect{@bot.report}.to output("unknown\n").to_stdout  
			end
			it "ignores surrounding spaces" do
				line = "   PLACE 0,1,WEST  "
				@bot.feed(line)
				expect{@bot.report}.to output("0,1,WEST\n").to_stdout 
			end
		end
		context "left" do
			it "changes from north to west" do 
				line = "PLACE 0,1,NORTH"
				@bot.feed(line)
				line = "LEFT"
				@bot.feed(line)
				expect{@bot.report}.to output("0,1,WEST\n").to_stdout 
			end
			it "changes from west to South" do 
				line = "PLACE 0,1,WEST"
				@bot.feed(line)
				line = "LEFT"
				@bot.feed(line)
				expect{@bot.report}.to output("0,1,SOUTH\n").to_stdout 
			end
			it "changes from South to east" do 
				line = "PLACE 0,1,South"
				@bot.feed(line)
				line = "LEFT"
				@bot.feed(line)
				expect{@bot.report}.to output("0,1,EAST\n").to_stdout 
			end
			it "changes from east to north" do 
				line = "PLACE 0,1,East"
				@bot.feed(line)
				line = "LEFT"
				@bot.feed(line)
				expect{@bot.report}.to output("0,1,NORTH\n").to_stdout 
			end
			it "ignores when no location" do
				line = "LEFT"
				@bot.feed(line)
				expect{@bot.report}.to output("unknown\n").to_stdout 
			end
		end
		context "right" do
			it "changes from north to east" do 
				line = "PLACE 0,1,North"
				@bot.feed(line)
				line = "RIGHT"
				@bot.feed(line)
				expect{@bot.report}.to output("0,1,EAST\n").to_stdout 
			end
			it "changes from west to north" do 
				line = "PLACE 0,1,West"
				@bot.feed(line)
				line = "right"
				@bot.feed(line)
				expect{@bot.report}.to output("0,1,NORTH\n").to_stdout 
			end
			it "ignores when no location" do
				line = "RIGHT"
				@bot.feed(line)
				expect{@bot.report}.to output("unknown\n").to_stdout 
			end
		end
		context "move" do
			it "increase X by 1" do 
				line = "PLACE 0,0,EAST"
				@bot.feed(line)
				line = "Move"
				@bot.feed(line)
				expect{@bot.report}.to output("1,0,EAST\n").to_stdout 
			end
			it "reduces X by 1" do 
				line = "PLACE 4,0,WEST"
				@bot.feed(line)
				line = "Move"
				@bot.feed(line)
				expect{@bot.report}.to output("3,0,WEST\n").to_stdout 
			end
			it "increase Y by 1" do 
				line = "PLACE 0,0,NORTH"
				@bot.feed(line)
				line = "Move"
				@bot.feed(line)
				expect{@bot.report}.to output("0,1,NORTH\n").to_stdout 
			end
			it "reduces Y by 1" do 
				line = "PLACE 0,4,SOUTH"
				@bot.feed(line)
				line = "Move"
				@bot.feed(line)
				expect{@bot.report}.to output("0,3,SOUTH\n").to_stdout 
			end
			it "not move off table to the EAST " do 
				line = "PLACE 4,0,EAST"
				@bot.feed(line)
				line = "Move"
				@bot.feed(line)
				expect{@bot.report}.to output("4,0,EAST\n").to_stdout 
			end
			it "not move off table to the WEST " do 
				line = "PLACE 0,0,WEST"
				@bot.feed(line)
				line = "Move"
				@bot.feed(line)
				expect{@bot.report}.to output("0,0,WEST\n").to_stdout 
			end
			it "not move off table to the NORTH " do 
				line = "PLACE 0,4,NORTH"
				@bot.feed(line)
				line = "Move"
				@bot.feed(line)
				expect{@bot.report}.to output("0,4,NORTH\n").to_stdout 
			end
			it "not move off table to the SOUTH" do 
				line = "PLACE 0,0,SOUTH"
				@bot.feed(line)
				line = "Move"
				@bot.feed(line)
				expect{@bot.report}.to output("0,0,SOUTH\n").to_stdout 
			end
		end
		context "report" do
			it "reports initial position" do
				line = "PLACE 2,3,SOUTH"
				@bot.feed(line)
				line = "Report"
				expect{@bot.feed(line)}.to output("2,3,SOUTH\n").to_stdout 
			end
			it "reports unknown position" do
				line = "Report"
				expect{@bot.feed(line)}.to output("unknown\n").to_stdout 
			end
		end
	end
end 