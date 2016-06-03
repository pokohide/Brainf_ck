require './brainf_ck'
include Brainf_ck

if ARGV[0] && File.exist?(ARGV[0])
  Brainf_ck::Interpreter.new(ARGF.read).run
else
  Brainf_ck::Interpreter.new(ARGV[0]).run
end
