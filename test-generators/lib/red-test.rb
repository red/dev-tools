module RedValues
    
    refine Integer do
        
        def to_red_binary
            bin_str = self.to_s(16).upcase
            bin_str.prepend('0'.slice(0, bin_str.bytesize % 2))
            '#{' + bin_str + '}'
        end
        
        def to_red_i256
            'to-i256 ' + self.to_red_binary
        end
    end
    
    refine Object do
        def to_red
            self.to_s
        end
    end
    
    refine String do
        def to_red
            '"' + self.to_s + '"'
        end
    end
               
end

using RedValues

class RedTest

    @test_file = ''
    class << self
        attr_accessor :test_file
    end
    
    def self.end_file
        self.puts "~~~end-file~~~"
    end
    
    def self.puts line
        self.test_file << line + "\n"
    end
    
    def self.start_file file_title
        self.puts 'Red []'
        self.puts ';#include  %../../../quick-test/quick-test.red'
        self.puts '~~~start-file~~~ "' + file_title + '"' + "\n"
    end
    
    attr_reader :title
    attr_accessor :test_num

    def initialize title
        @title = title
        @test_num = 0
    end
    
    def end_group
        RedTest.puts "===end-group===\n"
    end
    
    def generate_test_name
        self.test_num += 1
        RedTest.puts "\t" + '--test-- "' + self.title  + '-' + self.test_num.to_s + '"'
    end
    
    def set_word word, value, method=:to_red
        RedTest.puts "\t\t" + word + ': ' + value.send(method)
    end 

    def start_group 
        RedTest.puts '===start-group=== "' + self.title + '"'
    end

end

class RedFunc < RedTest
    
    attr_reader :red_fn
    
    def initialize title, red_fn
        super title
        @red_fn = red_fn
    end    
    
end

class RedFunc1ParamLambda < RedFunc

    attr_reader :test_list, :ruby_proc

    def initialize title, red_fn, ruby_proc, test_list
        super title, red_fn
        @test_list = test_list
        @ruby_proc = ruby_proc
    end
    
    def calc_expected x
        self.ruby_proc.call x
    end
    
    def generate_test x
        y = self.calc_expected x
        self.generate_test_name
        self.set_word 'x', x
        self.set_word 'y', y, :to_s
        RedTest.puts "\t\t--assert y = " + self.red_fn + " x\n"
    end
    
    def generate_test_group
        self.start_group
        self.test_num = 0
        y = self.test_list.each { |x| self.generate_test x}
        self.end_group
    end

end

class RedFunc2ParamsMethod < RedFunc
    
    attr_reader :test_pairs, :ruby_method
    
    def initialize title, red_fn, ruby_method, test_pairs
        super title, red_fn
        @test_pairs = test_pairs
        @ruby_method = ruby_method
    end
    
    def calc_expected x, y
        x.send self.ruby_method, y
    end
    
    def generate_test x, y
        z = self.calc_expected x, y
        if MIN_BIG < z and z < MAX_BIG then
            self.generate_test_name
            self.set_word 'x', x, :to_red_i256
            self.set_word 'y', y, :to_red_i256
            self.set_word 'z', z, :to_red_i256
            RedTest.puts "\t\t" + '--assert z  = ' + self.red_fn + ' x  y' + "\n"
        end
    end
    
    def generate_test_group
        self.start_group
        self.test_num = 0
        self.test_pairs.each { |x, y| self.generate_test x, y }
        self.end_group
    end

end

class RedComparisonMethod < RedFunc2ParamsMethod
    
    def generate_test x, y
        self.generate_test_name
        z = self.calc_expected x, y
        self.set_word 'x', x, :to_red_i256
        self.set_word 'y', y, :to_red_i256
        self.set_word 'z', z
        RedTest.puts "\t\t" + '--assert z  = ' + self.red_fn + ' x  y' + "\n"
    end
    
end
