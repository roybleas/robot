require_relative 'robot'

robot = Robot.new(Tablemap.new(4,8))
file_instructions = Instructions.new

ARGF.skip if ARGF.filename  == 'run_robot.rb'

ARGF.each do |line|
  file_instructions.extract_instructions(line)
end
	
file_instructions.instruction_set.each {| instruction| robot.feed(instruction) }
	

