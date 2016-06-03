module Brainf_ck
  class ProgramError < StandardError; end

  # 入力文字列をBrainf_ckに変換
  class Translator
  	def initialize(str)
  	  @chars = str.chars.to_a
  	end

  	def translate
      @chars.each do |chr|
      	num = chr.ord
      	divisor = Math.sqrt(num).round
      	dividend = num / divisor
      	remainder = num % divisor

      	bf = '+' * divisor + '[>' + '+' * dividend + '<-]>' + '+' * remainder + '.'
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
      	  chr = tape[cur] || 0
      	  print chr.chr
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
