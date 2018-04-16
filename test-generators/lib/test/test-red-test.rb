require 'minitest/autorun'
require_relative '../red-test'

using RedValues

describe RedTest do

  describe 'canary test' do
    it 'should pass' do
      true.must_equal true
    end
  end
  
  describe String do
    describe :to_red do
      it 'should return a copy of the string enclose in quotes' do
        'name'.to_red.must_equal '"name"'
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
  
  describe true do
    describe :to_red do
      it 'should return Red Word true' do
        true.to_red.must_equal 'true'
      end  
    end
  end
  
  describe false do
    describe :to_red do
      it 'should return Red Word false' do
        false.to_red.must_equal 'false'
      end  
    end
  end
  
  describe 'RedTest Class methods' do
    before do
      RedTest.test_file = ''
    end
    after do
      RedTest.test_file = ''
    end
    describe :add_to_test do
      it 'should add a string followed by new line to RedTest.testfile' do
        RedTest.add_to_test 'string'
        RedTest.test_file.must_equal "string\n"
      end
    end
    describe :start_file do  
      it 'should create test header and start-file' do
        expected = "Red []\n" +
                   ";#include  %../../../quick-test/quick-test.red\n" +
                   '~~~start-file~~~ "test one"'  + "\n\n"
        RedTest.start_file 'test one'
        RedTest.test_file.must_equal expected
      end
    end
    describe :end_file do
      it 'should create end-file and return the test file' do
        expected = "~~~end-file~~~\n"
        RedTest.end_file
        RedTest.test_file.must_equal expected
      end
    end
  end
  
  describe RedTest do
    before do
      @rt = RedTest.new 'unit_test'
      RedTest.test_file = ''
    end
    after do
      @rt = nil
      RedTest.test_file = ''
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
      it 'should add end group to a test file' do
        @rt.end_group
        RedTest.test_file.must_equal "===end-group===\n\n"
      end
    end
    describe :generate_test_name do
      it 'should increment test count and add a test header' do
        @rt.generate_test_name
        RedTest.test_file.must_equal "\t--test-- " + '"unit_test-1"' + "\n"
      end
    end
    describe :set_word do
      it 'should generate code to set a word to a Red value' do
        @rt.set_word 'x', 1
        RedTest.test_file.must_equal "\t\tx: 1\n"
      end
      it 'should optionally convert a value' do
        @rt.set_word 'y', 1, :to_red_i256
        RedTest.test_file.must_equal "\t\t" + 'y: to-i256 #{01}' + "\n"
      end
    end
    describe :start_group do
      it 'should add a group header' do
        @rt.start_group 
        RedTest.test_file.must_equal '===start-group=== "unit_test"' + "\n"
      end
    end

    
    
  end
  
end 