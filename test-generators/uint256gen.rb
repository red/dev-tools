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
srand 1
NUM_SMALL_SAMPLES.times { |i| single_values << rand(MAX_SMALL) }
NUM_BIG_SAMPLES.times { |i| single_values << rand(MAX_BIG) }
test_pairs = single_values.permutation(2).to_a
no_zero_divide_pairs = test_pairs.clone
no_zero_divide_pairs.keep_if { |pair| pair[1] != 0 }

includes = [
    '#include %../../red/quick-test/quick-test.red',
    '#include %../libs/int256.red'
]

gen_test = lambda do |context, x, y| 
    z = context.calc_expected x, y
    test = context.generate_test_name +
           context.set_word('x', x, :to_red_i256) +
           context.set_word('y', y, :to_red_i256)
    if MIN_BIG <= z and z <= MAX_BIG then
        test += context.set_word('z', z, :to_red_i256) +
                "\t\t" + '--assert z  = ' + context.red_fn + ' x  y' + "\n\n"
    else
        test += "\t\t" + '--assert error? try [ ' + context.red_fn + ' x  y ]' + "\n\n"
    end
end

gen_test_to_i256 = lambda do |context, x| 
    test = context.generate_test_name +
           context.set_word('x', x, :to_red_i256) +
           context.set_word('y', x.to_f) +
           "\t\t" + '--assert (' + context.red_fn + " x  to-i256 y) \n" +
           "\t\t and (" + context.red_fn + " to-i256 y x) \n\n"
end

gen_test_from_i256 = lambda do |context, x| 
    test = context.generate_test_name +
           context.set_word('x', x, :to_red_i256) +
           context.set_word('y', x.to_f) +
           "\t\t" + '--assert ' + context.red_fn + " i256-to-float x y \n\n"
end



gen_comp_test = lambda do |context, x, y|
    z = context.calc_expected x, y
    context.generate_test_name +
    context.set_word('x', x, :to_red_i256) +
    context.set_word('y', y, :to_red_i256) +
    context.set_word('z', z) +
    "\t\t" + '--assert z  = ' + context.red_fn + ' x  y' + "\n\n"
end

red_operators = [
    RedFunc2Params.new('add', 'add256', :+.to_proc, gen_test, test_pairs),
    RedFunc2Params.new('subtract', 'sub256', :-.to_proc, gen_test, test_pairs),
    RedFunc2Params.new('multiply', 'mul256', :*.to_proc, gen_test, test_pairs),
    RedFunc2Params.new('divide', 'div256', :/.to_proc, gen_test, no_zero_divide_pairs),
    RedFunc2Params.new('modulo', 'mod256', :%.to_proc, gen_test, no_zero_divide_pairs),
    RedFunc2Params.new('lesser or equal', 'lesser-or-equal256?', :<=.to_proc, 
                      gen_comp_test, test_pairs),
    RedFunc1Param.new('to-i256', 'lesser-or-equal256?', nil, gen_test_to_i256,
                      single_values),
    RedFunc1Param.new('i256-to-float', 'strict-equal?', nil, gen_test_from_i256,
                      single_values)
]

puts RedTest.start_file "uint256-generated", includes
red_operators.each { |red_op| puts red_op.generate_test_group }
puts RedTest.end_file
