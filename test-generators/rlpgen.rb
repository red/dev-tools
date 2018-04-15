require 'rlp'
include RLP
require_relative 'lib/red-test'

encode_test_data = [
    'dog',
    '12345678901234567890123456789012345678901234567890123456',
    '123456789012345678901234567890123456789012345678901234567',
    100
]

## lambda returns a ready molded Red value
encode = lambda do |value| 
    enc = RLP.encode(value).unpack('H*')
    '#{' + enc[0] + '}'                          
end

rlp_tests = [
    RedFunc1ParamLambda.new('encode', 'rlp/encode', encode, encode_test_data)
]

RedTest.start_file 'rlp-generated'
rlp_tests.each { |rlp_test| rlp_test.generate_test_group }
RedTest.end_file
puts RedTest.test_file