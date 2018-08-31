require 'minitest/autorun'
require_relative '../red-test'

using RedValues

describe RedTest do

  describe 'canary test' do
    it 'should pass' do
      true.must_equal true
    end
  end
  
  describe BigDecimal do
  
    describe :to_dec64_string do
      it 'should return "1.0" from 1' do
        BigDecimal(1).to_dec64_string.must_equal '1.0'
      end
      it 'should return "-1.0" for -1.0' do
        BigDecimal(-1).to_dec64_string.must_equal '-1.0'
      end
      it 'should return "0.0" for 0.0' do
        BigDecimal(0).to_dec64_string.must_equal '0.0'
      end
    #  it 'should return "123456789012345680.0" for 123456789012345678' do
    #    BigDecimal(123456789012345678).to_dec64_string.must_equal "123456789012345680.0"
    #  end
      it 'should return "1234567.0" for 1234567' do
        BigDecimal(1234567).to_dec64_string.must_equal "1234567.0"
      end
    #  it 'should return "0.012345678901234568" for 0.0123456789012345678' do
    #   bd = BigDecimal(123456789012345678) / BigDecimal(10000000000000000000)
    #  bd.to_dec64_string.must_equal "0.012345678901234568"
    #  end
      it 'should return "0.01234567" for 0.01234567' do
        bd = BigDecimal(1234567) / BigDecimal(100000000)
        bd.to_dec64_string.must_equal "0.01234567"
      end
    # it 'should return "-123456789012345670.0" for -123456789012345678' do
    #    BigDecimal(-123456789012345678).to_dec64_string.must_equal "-123456789012345680.0"
    #  end
      it 'should return "-12345670.0" for -12345671' do
        BigDecimal(-12345671).to_dec64_string.must_equal "-12345670.0"
      end
      it 'should return "-0.01234567" for -0.012345674' do
        bd = BigDecimal(-12345674) / BigDecimal(1000000000)
        bd.to_dec64_string.must_equal "-0.01234567"
      end
      it 'should return "Nan" for NaN' do
        BigDecimal('NaN').to_dec64_string.must_equal "NaN"
      end
      it 'should return "Nan" for Infinity' do
        BigDecimal('Infinity').to_dec64_string.must_equal "NaN"
      end
      it 'should return "Nan" for -Infinity' do
        BigDecimal('-Infinity').to_dec64_string.must_equal "NaN"
      end
    #  it 'should handle max value' do
    #   bd = BigDecimal(36028797018963967) * 1e127
    #    BigDecimal(bd).to_dec64_string.must_equal "360287970189639670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.0"
    #  end
      it 'should handle max value' do
        bd = BigDecimal(8388607) * 1e127
        BigDecimal(bd).to_dec64_string.must_equal "83886070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.0"
      end
      it 'should return "NaN" for too big number' do
        bd = BigDecimal(36028797018963967) * 1e127 + 1
        BigDecimal(bd).to_dec64_string.must_equal "NaN"
      end
      it 'should return "NaN" for too big negative number' do
        bd = BigDecimal(-36028797018963967) * 1e127 - 1
        BigDecimal(bd).to_dec64_string.must_equal "NaN"
      end
      it 'should return "0.0" for a very small number' do
        bd = BigDecimal(1) * 1e-128
        BigDecimal(bd).to_dec64_string.must_equal '0.0'
      end
    #  it 'should return "123456789012345640.0" for 123456789012345644' do
    #    BigDecimal(123456789012345644).to_dec64_string.must_equal "123456789012345640.0"
    #  end
      it 'should return "12345670.0" for 12345674' do
        BigDecimal(12345674).to_dec64_string.must_equal "12345670.0"
      end
    #  it 'should return "0.012345678901234564" for 0.0123456789012345644' do
    #   bd = BigDecimal(123456789012345644) / BigDecimal(10000000000000000000)
    #    bd.to_dec64_string.must_equal "0.012345678901234564"
    #  end
      it 'should return "0.01234564" for 0.012345644' do
        bd = BigDecimal(12345644) / BigDecimal(1000000000)
        bd.to_dec64_string.must_equal "0.01234564"
      end
    #  it 'should return "-123456789012345640.0" for -123456789012345644' do
    #    BigDecimal(-123456789012345644).to_dec64_string.must_equal "-123456789012345640.0"
    #  end
      it 'should return "-12345640.0" for -12345644' do
        BigDecimal(-12345644).to_dec64_string.must_equal "-12345640.0"
      end
    #  it 'should return "-0.012345678901234564" for -0.0123456789012345644' do
    #    bd = BigDecimal(-123456789012345644) / BigDecimal(10000000000000000000)
    #   bd.to_dec64_string.must_equal "-0.012345678901234564"
    #  end 
      it 'should return "-0.01234567" for -0.01234567' do
        bd = BigDecimal(-1234567) / BigDecimal(100000000)
        bd.to_dec64_string.must_equal "-0.01234567"
      end
      it 'should handle max neg value + smallest pos value' do
        x = BigDecimal(-8388608) * (BigDecimal(10) ** BigDecimal(127))
        y = BigDecimal(1) * (BigDecimal(10) ** BigDecimal(-127))
        z = x + y
        z.to_dec64_string.must_equal "-83886080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.0"
      end 
    end
    
    describe :to_red_money do
      it 'should return a money string literal' do 
        BigDecimal(0).to_red_money.must_equal '$0.0'
      end
      it 'should return a negative money string literal' do
        BigDecimal(-1).to_red_money.must_equal '-$1.0'
      end
    #  it 'should handle max value' do
    #   bd = BigDecimal(36028797018963967) * 1e127
    #    BigDecimal(bd).to_red_money.must_equal "$360287970189639670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.0"
    #  end
      it 'should handle max value' do
        bd = BigDecimal(8388607) * 1e127
        BigDecimal(bd).to_red_money.must_equal "$83886070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.0"
      end
    #  it 'should handle min value' do
    #    bd = BigDecimal(-36028797018963967) * 1e127
    #    bd.to_red_money.must_equal "-$360287970189639670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.0"
    #  end
      it 'should handle min value' do
        bd = BigDecimal(-8388607) * 1e127
        bd.to_red_money.must_equal "-$83886070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.0"
      end
      it 'should convert infinity to nan' do
        BigDecimal('Infinity').to_red_money.must_equal '$NaN'
      end
      it 'should convert +infinity to nan' do
        BigDecimal('+Infinity').to_red_money.must_equal '$NaN'
      end
      it 'should convert infinity to nan' do
        BigDecimal('-Infinity').to_red_money.must_equal '$NaN'
      end
      it 'should handle nan' do
        BigDecimal('NaN').to_red_money.must_equal '$NaN'
      end
      it 'should return nan for too big numbers' do
        bd = BigDecimal(1) * 1e256
        bd.to_red_money.must_equal '$NaN'
      end
      it 'should return $0.0 for too small numbers' do
        bd = BigDecimal(1) * 1e-256
        bd.to_red_money.must_equal '$0.0'
      end
    end
    describe :to_to_red_money do
      it 'should return to money! "number"' do
        BigDecimal(10).to_to_red_money.must_equal 'to money! "10.0"'
      end
      it 'should return to money! "9999999999999999999" for NaN' do
        BigDecimal('NaN').to_to_red_money.must_equal 'to money! "9999999999999999999"'
      end
    end
  end
  
  describe Integer do
    describe :to_red do
      it 'should return an integer string literal' do
        12345.to_red.must_equal '12345'
      end
      it 'should include a - sign for negative numbers' do
        -12.to_red.must_equal '-12'
      end
    end
    describe :to_red_binary do
      it 'should convert a single digit integer to a Red binary literal' do
        1.to_red_binary.must_equal '#{01}'
      end
      it 'should convert a hex double digit integer to a Red binary literal' do
        0xFF.to_red_binary.must_equal '#{FF}'
      end
      it 'should convert a big integer' do
        0xFEDCBA9876543210123456789ABCDEF.to_red_binary
                                         .must_equal '#{0FEDCBA9876543210123456789ABCDEF}'
      end
    end
    describe :to_red_i256 do
      it 'should return to-i256 followed by a red binary literal' do
        1.to_red_i256.must_equal 'to-i256 #{01}'
      end
    end
  end
  
  describe Object do
    describe :to_red do
      it 'should return Red Word false for false' do
        false.to_red.must_equal 'false'
      end
      it 'should return Red Word truwefor true' do
        true.to_red.must_equal 'true'
      end  
    end
    describe :unchanged do
      it 'should return itself' do
        itself = 1
        itself.unchanged.must_equal 1
      end
    end
  end
  
  describe String do
    describe :to_red do
      it 'should return a copy of the string enclose in quotes' do
        'name'.to_red.must_equal '"name"'
      end
      it 'should escape " within a string' do
        ' "Red" '.to_red.must_equal '" ^"Red^" "'
      end
    end
  end
  
    
  describe 'RedTest Class methods' do
    describe :start_file do  
      it 'should create test header and start-file' do
        expected = "Red []\n\n" +
                   "a\n" + "b\n" + "c\n\n"+
                   '~~~start-file~~~ "test one"'  + "\n\n"
        RedTest.start_file('test one', ['a', 'b', 'c']).must_equal expected
      end
    end
    describe :end_file do
      it 'should create end-file and return the test file' do
        expected = "~~~end-file~~~\n"
        RedTest.end_file.must_equal expected
      end
    end
  end
  
  describe RedTest do
    before do
      @rt = RedTest.new 'unit_test'
    end
    after do
      @rt = nil
    end
    describe :new do
      it 'should set test count to 0' do
        @rt.test_num.must_equal 0
      end
      it 'should set the title to unit_test' do
        @rt.title.must_equal 'unit_test'
      end
    end
    describe :end_group do
      it 'should return an end group' do
        @rt.end_group.must_equal "===end-group===\n\n"
      end
    end
    describe :generate_test_name do
      it 'should increment test count and produce a test header' do
        @rt.generate_test_name.must_equal "\t--test-- " + '"unit_test-1"' + "\n"
      end
    end
    describe :set_word do
      it 'should generate code to set a word to a Red value' do
        @rt.set_word('x', 1).must_equal "\t\tx: 1\n"
      end
      it 'should optionally convert a value' do
        @rt.set_word('y', 1, :to_red_i256).must_equal "\t\t" + 'y: to-i256 #{01}' + "\n"
      end
    end
    describe :start_group do
      it 'should produce a group header' do
        @rt.start_group.must_equal '===start-group=== "unit_test"' + "\n"
      end
    end
  end
  
  describe RedFunc do
    after do
      @rt = nil
    end
    describe :calc_expected do
      it 'should call a proc with one argument' do
        @rt = RedFunc.new 'calc_expected', 'red_func', :next.to_proc, nil
        @rt.calc_expected(1).must_equal 2
      end
      it 'should call a proc with two arguments' do
        @rt = RedFunc.new 'calc_expected', '+', :+.to_proc, nil
        @rt.calc_expected(1, 2).must_equal 3
      end
    end
    describe :generate_test do
      it 'should supply a proc with a context' do
        lam = lambda { |context| context.title } 
        @rt = RedFunc.new 'generate_test', 'red_func', :+.to_proc, lam
        @rt.generate_test.must_equal 'generate_test' 
      end
      it 'should pass 1 argument to the proc' do
        lam = lambda { |context, i| i } 
        @rt = RedFunc.new 'generate_test', 'red_func', :+.to_proc, lam
        @rt.generate_test(1).must_equal 1 
      end
      it 'should supply 2 arguments to a proc' do
        lam = lambda { |context, i, j| i + j } 
        @rt = RedFunc.new 'generate_test', 'red_func', :+.to_proc, lam
        @rt.generate_test(2, 3).must_equal 5 
      end      
    end
  end
  
  describe RedFunc1Param do
    describe :generate_test_group do
      after do
        @rf1p = nil
      end
      it 'should generate group start, some test and group end' do
        test_lam = lambda { |context, i| "test for #{i}" }        
        exp = '===start-group=== "RF1Ptest"' + "\n" +
              'test for 1' + 'test for 10' +
              "===end-group===\n\n"
        @rf1p = RedFunc1Param.new 'RF1Ptest', 'next', :next.to_proc, test_lam, [1, 10]
        @rf1p.generate_test_group.must_equal exp
      end
    end    
  end
  
  describe RedFunc2Params do
    describe :generate_test_group do
      after do
        @rf1p = nil
      end
      it 'should generate group start, some test and group end' do
        test_lam = lambda { |context, i, j| "test for #{i + j}" }        
        exp = '===start-group=== "RF1Ptest"' + "\n" +
              'test for 11' + 'test for 22' +
              "===end-group===\n\n"
        @rf1p = RedFunc2Params.new 'RF1Ptest', 'next', :next.to_proc, test_lam, 
                                  [[1, 10], [2, 20]]
        @rf1p.generate_test_group.must_equal exp
      end
    end    
  end
    
end 