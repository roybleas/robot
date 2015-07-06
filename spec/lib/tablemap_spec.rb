require "spec_helper"
require '././robot'

describe Tablemap do
	context "initialization" do
		it "creates a default map" do
			table = Tablemap.new
			expect(table.size).to eq(5)
		end
		it "creates a custom map" do
			table = Tablemap.new(8)
			expect(table.size).to eq(8)
		end
	end
	
	context "confirm location" do
		before(:each) do
			@table = Tablemap.new
		end
		
		it "lies within map" do
			loc = Location.new(2,3)
			expect(@table.valid_location?(loc)).to be_truthy
		end
		it "lies on bottom sw corner of map" do
			loc = Location.new(0,0)
			expect(@table.valid_location?(loc)).to be_truthy
		end		
		it "lies on top nw corner of map" do
			loc = Location.new(0,4)
			expect(@table.valid_location?(loc)).to be_truthy
		end
		it "lies on bottom se corner of map" do
			loc = Location.new(4,0)
			expect(@table.valid_location?(loc)).to be_truthy
		end
		it "lies on top ne corner of map" do
			loc = Location.new(4,4)
			expect(@table.valid_location?(loc)).to be_truthy
		end
	end
	
	context "report invalid location" do
		before(:each) do
			@table = Tablemap.new
		end

		it "when lies beyond north of map" do
			loc = Location.new(4,5)
			expect(@table.valid_location?(loc)).to be_falsey
		end
		it "when lies beyond east of map" do
			loc = Location.new(5,4)
			expect(@table.valid_location?(loc)).to be_falsey
		end
		it "when lies beyond south of map" do
			loc = Location.new(4,-1)
			expect(@table.valid_location?(loc)).to be_falsey
		end
		it "when lies beyond west of map" do
			loc = Location.new(-1,4)
			expect(@table.valid_location?(loc)).to be_falsey
		end
	end
end