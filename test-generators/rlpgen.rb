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

gen_test = lambda do |context, x|
    y = context.calc_expected x
    context.generate_test_name +
    context.set_word('x', x) +
    context.set_word('y', y, :to_s) +
    "\t\t--assert y = " + context.red_fn + " x\n\n"
end

rlp_tests = [
    RedFunc1Param.new('encode', 'rlp/encode', encode, gen_test, encode_test_data)
]
includes = [
    '#include %../../red/quick-test/quick-test.red',
    '#include %../keys/Ledger/rlp.red',
    '#include %../libs/int256.red'
]

puts RedTest.start_file 'rlp-generated', includes 
rlp_tests.each { |rlp_test| puts rlp_test.generate_test_group }
puts RedTest.end_file
