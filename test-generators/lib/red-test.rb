# A set of classes and refinements that allow easy generation of Red test files
#
# Author: Peter W A Wood
#
# Copyright © 2018 Red Foundation
#
# Licence: BSD-3 - https://github.com/red/red/blob/origin/BSD-3-License.txt
#
# Version: 1.0.0

require 'bigdecimal'

module RedValues
    
    TEN = BigDecimal 10
    MAX_MONEY = BigDecimal(0x00FFFFFFFFFFFFFF) * (TEN ** BigDecimal(127))
    MIN_MONEY = BigDecimal(1) * (TEN ** BigDecimal(-127))

    refine BigDecimal do
      def to_red_money
        return '$NaN' if self.infinite? or self.nan? or self > MAX_MONEY
        return '$0.0' if self.abs < MIN_MONEY
        if self < 0 then
          '-$' + self.abs().to_s('F')  
        else
          '$' + self.to_s('F')
        end
      end
      
      def to_to_red_money
        ns = []
        s = self.round(17).to_s('F')
        count = 0
        non_zero_found = false
        s.each_char do |c|
          if c == '.' or c == '-' then
            ns.push(c)
          else
            non_zero_found = true if c != '0'
            count += 1 if non_zero_found
            if count > 17 then
              ns.push('0')
            else
              ns.push(c)
            end
          end
        end
        'to money! "' + ns.join + '"'
      end      
    end
    
    
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
        
        def unchanged
            self
        end
    end
    
    refine String do
        def to_red
            '"' + self.to_s.gsub('"', '^"') + '"'
        end
    end
               
end

using RedValues

class RedTest

    def self.end_file
        "~~~end-file~~~\n"
    end
    
    def self.start_file file_title, includes
        header = 'Red []' + "\n\n"
        includes.each { |include| header += include + "\n" }
        header += "\n" + '~~~start-file~~~ "' + file_title + '"' + "\n\n"
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
    
    attr_reader :red_fn, :ruby_proc, :test_proc
    
    def initialize title, red_fn, ruby_proc, test_proc
        super title
        @red_fn = red_fn
        @ruby_proc = ruby_proc
        @test_proc = test_proc
    end
    
    def calc_expected *args
        self.ruby_proc.call(*args)
    end
    
    def generate_test *args
        self.test_proc.call(self, *args)
    end
        
end

class RedFunc1Param < RedFunc

    attr_reader :test_list

    def initialize title, red_fn, ruby_proc, test_proc, test_list
        super title, red_fn, ruby_proc, test_proc
        @test_list = test_list
    end
    
    def generate_test_group
        test_group = self.start_group
        self.test_list.each { |x|  test_group += self.generate_test x}
        test_group += self.end_group
    end

end

class RedFunc2Params < RedFunc
    
    attr_reader :test_pairs
    
    def initialize title, red_fn, ruby_proc, test_proc, test_pairs
        super title, red_fn, ruby_proc, test_proc
        @test_pairs = test_pairs
    end
    
    def generate_test_group
        test_group = self.start_group
        self.test_pairs.each { |x, y| test_group += self.generate_test x, y }
        test_group += self.end_group
    end

end
