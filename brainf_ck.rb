module Brainf_ck
  class ProgramError < StandardError; end

  # 入力文字列をBrainf_ckに変換
  class Translator
  	def initialize(str)
  	  @chars = str.chars.to_a
  	end

  	def translate
  	  require 'prime'
      @chars.each_with_index do |chr, i|
      	@num = chr.ord
      	diff = (defined? @ex_num) ? (@num - @ex_num) : @num
      	@ex_num = @num

      	sign = (diff > 0) ? '+' : '-'
      	diff = diff.abs

      	bf = if diff > 5
      	    divisor = Math.sqrt(diff).round
      	    dividend = diff / divisor
      	    remainder = diff % divisor
      	    ( i.zero? ? '' : '<' ) + '+' * divisor + '[>' + sign * dividend + '<-]>' + sign * remainder + '.'
      	  elsif diff == 0
			'.'
		  else
		    sign * diff + '.'  
      	  end
      	print bf
      end
  	end
  end

  class Interpreter
    def initialize(src)
      @tokens = src.chars.to_a
      @jumps = analyze_jumps(@tokens)
    end

    def run
      tape = []
      pc = 0
      cur = 0

      while pc < @tokens.size
        case @tokens[pc]
        when '+'
      	  tape[cur] ||= 0
      	  tape[cur] += 1
        when '-'
      	  tape[cur] || 0
      	  tape[cur] -= 1
        when '>'
      	  cur += 1
        when '<'
      	  cur -= 1
      	  raise ProgramError, '開始位置より左には移動できません' if cur < 0
        when '.'
      	  n = tape[cur] || 0
      	  print n.chr
        when ','
      	  tape[cur] = $stdin.getc
        when '['
      	  pc = @jumps[pc] if tape[cur].zero?
        when ']'
      	  pc = @jumps[pc] if tape[cur].nonzero?
      	end
      	pc += 1
      end
    end

    private
    def analyze_jumps(tokens)
  	  jumps = {}
  	  starts = []

  	  tokens.each_with_index do |t, i|
  	    if t == '['
  	  	  starts.push(i)
  	    elsif t == ']'
  	  	  raise ProgramError, '"["と"]"の数がマッチしていません。"]"が多すぎます' if starts.empty?
  	  	  from = starts.pop
  	  	  to = i

  	  	  jumps[from] = to
  	  	  jumps[to] = from
  	    end
  	  end
  	  raise ProgramError, '"["と"]"の数がマッチしていません。"["が多すぎます' unless starts.empty?
  	  return jumps
    end
  end
end
