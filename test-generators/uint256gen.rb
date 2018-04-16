require_relative 'lib/red-test'

##  Add random seed ##

ZERO = 0
ONE = 1
TWO = 2
MAX_SMALL = 0xFFFFFFFFFFFFFFFF
MIN_BIG = ZERO
MAX_BIG = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
NUM_SMALL_SAMPLES = 10
NUM_BIG_SAMPLES = 10
single_values = [MIN_BIG, ZERO, ONE, TWO, MAX_BIG]
srand 1
NUM_SMALL_SAMPLES.times { |i| single_values << rand(MAX_SMALL) }
NUM_BIG_SAMPLES.times { |i| single_values << rand(MAX_BIG) }
test_pairs = single_values.permutation(2).to_a
no_zero_divide_pairs = test_pairs.clone
no_zero_divide_pairs.keep_if { |pair| pair[1] != 0 }

red_operators = [
    RedFunc2Params.new('add', 'add256', :+.to_proc, test_pairs),
    RedFunc2Params.new('subtract', 'sub256', :-.to_proc, test_pairs),
    RedFunc2Params.new('multiply', 'mul256', :*.to_proc, test_pairs),
    RedFunc2Params.new('divide', 'div256', :/.to_proc, no_zero_divide_pairs),
    RedFunc2Params.new('modulo', 'mod256', :%.to_proc, no_zero_divide_pairs),
    RedComparison.new('lesser or equal', 'lesser-or-equal256?', :<=.to_proc, test_pairs)
]

test_file = RedTest.start_file "uint256-generated"
red_operators.each { |red_op| test_file += red_op.generate_test_group }
test_file += RedTest.end_file
puts test_file