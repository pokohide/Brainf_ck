require './brainf_ck'
include Brainf_ck

if ARGV[0] && File.exist?(ARGV[0])
  Brainf_ck::Translator.new(ARGF.read).translate
else
  Brainf_ck::Translator.new(ARGV[0]).translate
end