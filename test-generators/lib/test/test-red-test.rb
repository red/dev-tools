require 'minitest/autorun'
require_relative '../red-test'

using RedValues

describe RedTest do

  describe 'canary test' do
    it 'should pass' do
      true.must_equal true
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
  
end 