require "spec_helper"
require '././lib/robot/instructions'

describe Instruction do
	context "initialization" do
		it "creates an instruction" do
			instruct = Instruction.new(:move)
			expect(instruct.action).to eq(:move)
			expect(instruct.location).to be_nil
		end
		it "has classes with equality" do
			instructA = Instruction.new(:move)
			instructB = Instruction.new(:move)
			expect(instructA).to eq(instructB)
			instructC = Instruction.new(:left)
			expect(instructA).to_not eq(instructC)
		end
		it "has classes with equality including location" do
			loc = Location.new("1,2,EAST")
			instructA = Instruction.new(:place)
			instructA.location = loc
			instructB = Instruction.new(:place)
			instructB.location = loc
			expect(instructA).to eq(instructB)
			instructB.location.x = 3
			expect(instructA).to_not eq(instructB)
			
		end
	end
	context "with location" do
		before(:each) do
			@loc = Location.new("1,2,EAST")
			@instruct = Instruction.new(:place)
			@instruct.location = @loc

		end

		it "stores a location" do
			expect(@instruct.location.x).to eq(1)
			expect(@instruct.location.y).to eq(2)
			expect(@instruct.location.facing).to eq("EAST")
		end
		
		it "stores a copy of location" do
			@loc.facing = "NORTH"
			@loc.x = 5
			expect(@instruct.location.x).to eq(1)
			expect(@instruct.location.y).to eq(2)
			expect(@instruct.location.facing).to eq("EAST")
		end
		
		it "stores a copy of location" do
			@instruct.location.facing = "South"
			@instruct.location.y = 3
			expect(@loc.x).to eq(1)
			expect(@loc.y).to eq(2)
			expect(@loc.facing).to eq("EAST")
		end
	end
end

describe Instructions do
	
	context "action validation" do
		it {expect(Instructions.new.is_valid_action?("place")).to be_truthy}
		it {expect(Instructions.new.is_valid_action?("move")).to be_truthy}
		it {expect(Instructions.new.is_valid_action?("LEFT")).to be_truthy}
		it {expect(Instructions.new.is_valid_action?("RIGHT")).to be_truthy}
		it {expect(Instructions.new.is_valid_action?("REPORT")).to be_truthy}
	end
	context "action validation failures" do
		it {expect(Instructions.new.is_valid_action?("place ")).to be_falsey}
		it {expect(Instructions.new.is_valid_action?("mve")).to be_falsey}
		it {expect(Instructions.new.is_valid_action?("")).to be_falsey}
		it {expect(Instructions.new.is_valid_action?(" ")).to be_falsey}
		it {expect(Instructions.new.is_valid_action?("REPORTMOVE")).to be_falsey}
	end
	context "location validations" do
		it {expect(Instructions.new.is_valid_location?("1,2,NORTH")).to be_truthy}
		it {expect(Instructions.new.is_valid_location?("3,4,South")).to be_truthy}
		it {expect(Instructions.new.is_valid_location?("5,11,EAST")).to be_truthy}
		it {expect(Instructions.new.is_valid_location?("12,6,west")).to be_truthy}
	end
	
	context "location validation faliures" do
		it {expect(Instructions.new.is_valid_location?("NORTH")).to be_falsey}
		it {expect(Instructions.new.is_valid_location?("3 , 4, South")).to be_falsey}
		it {expect(Instructions.new.is_valid_location?("5,EAST")).to be_falsey}
		it {expect(Instructions.new.is_valid_location?("12,6")).to be_falsey}
	end
	
	context "extract instructions" do
		context "other than PLACE " do
			it "with a single valid instruction" do
				ins = Instructions.new
				ins.extract_instructions("LEFT")
				expected_list = [Instruction.new(:left)]
				expect(ins.instruction_set).to match_array(expected_list)
			end
			it "with multiple valid instructions" do
				ins = Instructions.new
				ins.extract_instructions("RIGHT MOVE REPORT")
				expected_list = [Instruction.new(:right), Instruction.new(:move),Instruction.new(:report)]
				expect(ins.instruction_set).to match_array(expected_list)
			end
		end
	end
	context "PLACE and Location" do
		it "with valid place instruction and location" do
			ins = Instructions.new
			ins.extract_instructions("PLACE 0,0,NORTH")
			place_instruction = Instruction.new(:place)
			place_instruction.location = Location.new("0,0,NORTH")
			expected_list = [place_instruction]
			expect(ins.instruction_set).to match_array(expected_list)
		end
		it "with invalid location" do
			ins = Instructions.new
			ins.extract_instructions("PLACE 0,0,NORTHEAST")
			expected_list = []
			expect(ins.instruction_set).to be_empty
		end
		
		it "with missing location" do
			ins = Instructions.new
			ins.extract_instructions("PLACE")
			expected_list = []
			expect(ins.instruction_set).to be_empty
		end
		
		it "with location after move" do
			ins = Instructions.new
			ins.extract_instructions("MOVE 0,0,NORTHEAST")
			expected_list = [Instruction.new(:move)]
			expect(ins.instruction_set).to match_array(expected_list)
		end
		
		it "with only location" do
			ins = Instructions.new
			ins.extract_instructions("0,0,EAST")
			expected_list = []
			expect(ins.instruction_set).to be_empty
		end
		it "has multiple lines" do
			ins = Instructions.new
			ins.extract_instructions("PLACE 0,0,EAST\n")
			ins.extract_instructions("LEFT")
			place_instruction = Instruction.new(:place)
			place_instruction.location = Location.new("0,0,EAST")
			left_instruction = Instruction.new(:left)
			expected_list = [place_instruction,left_instruction]
			expect(ins.instruction_set).to match_array(expected_list)
		end
			
			
	end
	context "treat lines # as a comment" do
		it " ignores instruction as preceded by #" do
			line = "   # LEFT"
			ins = Instructions.new
			ins.extract_instructions(line)
			expected_list = [Instruction.new(:left)]
			expect(ins.instruction_set).to be_empty
		end
	end
end
