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
        "~~~end-file~~~\n"
    end
    
    def self.start_file file_title
        'Red []' + "\n" +
        ';#include  %../../../quick-test/quick-test.red' + "\n" +
        '~~~start-file~~~ "' + file_title + '"' + "\n\n"
    end
    
    attr_reader :title
    attr_accessor :test_num

    def initialize title
        @title = title
        @test_num = 0
    end
    
    def end_group
        "===end-group===\n\n"
    end
    
    def generate_test_name
        self.test_num += 1
        "\t" + '--test-- "' + self.title  + '-' + self.test_num.to_s + '"' + "\n"
    end
    
    def set_word word, value, method=:to_red
        "\t\t" + word + ': ' + value.send(method) +"\n"
    end 

    def start_group 
        @test_num = 0
        '===start-group=== "' + self.title + '"' + "\n"
    end

end

class RedFunc < RedTest
    
    attr_reader :red_fn, :ruby_proc
    
    def initialize title, red_fn, ruby_proc
        super title
        @red_fn = red_fn
        @ruby_proc = ruby_proc
    end
        
end

class RedFunc1Param < RedFunc

    attr_reader :test_list

    def initialize title, red_fn, ruby_proc, test_list
        super title, red_fn, ruby_proc
        @test_list = test_list
        @ruby_proc = ruby_proc
    end
    
    def calc_expected x
        self.ruby_proc.call x
    end    

    def generate_test x
        y = self.calc_expected x
        self.generate_test_name +
        self.set_word('x', x) +
        self.set_word('y', y, :to_s) +
        "\t\t--assert y = " + self.red_fn + " x\n\n"
    end
    
    def generate_test_group
        test_group = self.start_group
        self.test_list.each { |x|  test_group += self.generate_test x}
        test_group += self.end_group
    end

end

class RedFunc2Params < RedFunc
    
    attr_reader :test_pairs
    
    def initialize title, red_fn, ruby_proc, test_pairs
        super title, red_fn, ruby_proc
        @test_pairs = test_pairs
    end
    
    def calc_expected x, y
        self.ruby_proc.call x, y
    end    
    
    def generate_test x, y
        z = self.calc_expected x, y
        if MIN_BIG < z and z < MAX_BIG then
            result = self.generate_test_name +
            self.set_word('x', x, :to_red_i256) +
            self.set_word('y', y, :to_red_i256) +
            self.set_word('z', z, :to_red_i256) +
            "\t\t" + '--assert z  = ' + self.red_fn + ' x  y' + "\n\n"
        end
        result
    end
    
    def generate_test_group
        test_group = self.start_group
        self.test_pairs.each do |x, y|
          result = self.generate_test x, y 
          test_group += result if result
        end
        test_group += self.end_group
    end

end

class RedComparison < RedFunc2Params
    
    def generate_test x, y
        z = self.calc_expected x, y
        self.generate_test_name +
        self.set_word('x', x, :to_red_i256) +
        self.set_word('y', y, :to_red_i256) +
        self.set_word('z', z) +
        "\t\t" + '--assert z  = ' + self.red_fn + ' x  y' + "\n\n"
    end
    
end
