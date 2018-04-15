require_relative 'lib/red-test'

ZERO = 0
ONE = 1
TWO = 2
MAX_SMALL = 0xFFFFFFFFFFFFFFFF
MIN_BIG = ZERO
MAX_BIG = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
NUM_SMALL_SAMPLES = 10
NUM_BIG_SAMPLES = 10
single_values = [MIN_BIG, ZERO, ONE, TWO, MAX_BIG]
NUM_SMALL_SAMPLES.times { |i| single_values << rand(MAX_SMALL) }
NUM_BIG_SAMPLES.times { |i| single_values << rand(MAX_BIG) }
test_pairs = single_values.permutation(2).to_a
no_zero_divide_pairs = test_pairs.clone
no_zero_divide_pairs.keep_if { |pair| pair[1] != 0 }

red_operators = [
    RedFunc2ParamsMethod.new('add', 'add256', :+, test_pairs),
    RedFunc2ParamsMethod.new('subtract', 'sub256', :-, test_pairs),
    RedFunc2ParamsMethod.new('multiply', 'mul256', :*, test_pairs),
    RedFunc2ParamsMethod.new('divide', 'div256', :/, no_zero_divide_pairs),
    RedFunc2ParamsMethod.new('modulo', 'mod256', :%, no_zero_divide_pairs),
    RedComparisonMethod.new('lesser or equal', 'lesser-or-equal256?', :<=, test_pairs)
]

RedTest.start_file "uint256-generated"
red_operators.each { |red_op| red_op.generate_test_group }
RedTest.end_file
puts RedTest.test_file