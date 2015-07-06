require_relative 'toyrobot'

toyrobot = Toyrobot.new()

ARGF.skip if ARGF.filename  == 'run_toyrobot.rb'

ARGF.each do |line|
  toyrobot.feed(line)
end
	
