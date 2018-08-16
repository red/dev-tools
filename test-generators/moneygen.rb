require 'bigdecimal'
require_relative 'lib/red-test'


ZERO = BigDecimal 0
ONE = BigDecimal 1
TWO = BigDecimal 2
TEN = BigDecimal 10
MINUS_ONE = BigDecimal -1
MIN_COEFFICIENT = ZERO
MAX_POS_COEFFICIENT = BigDecimal 8388607
MAX_NEG_COEFFICIENT = BigDecimal -8388608
MIN_EXPONENT = BigDecimal -127
MAX_EXPONENT = BigDecimal 127
MAX_NEG = MAX_NEG_COEFFICIENT * (TEN ** MAX_EXPONENT)
MAX_POS = MAX_POS_COEFFICIENT * (TEN ** MAX_EXPONENT)
MIN = BigDecimal(1) * (TEN ** MIN_EXPONENT)
NUM_SAMPLES = 20
single_values = [MAX_NEG, ZERO, MIN, ONE, TWO, MINUS_ONE, MAX_NEG]
srand 1
NUM_SAMPLES.times do |i|
  coeff = rand(MAX_NEG_COEFFICIENT..MAX_POS_COEFFICIENT)
  if coeff < 0 then
    max_coeff = 8388608
  else
    max_coeff = 8388607
  end
  if coeff.split[1].slice(0,7).to_i.abs > max_coeff then
    sig_digits = 6
  else
    sig_digits = 7
  end
  coeff = coeff.round(sig_digits - coeff.split[3])
  exp = rand(MIN_EXPONENT..MAX_EXPONENT)
  single_values << coeff * (TEN ** exp)
end
test_pairs = single_values.permutation(2).to_a

includes = [
    '#include %../../../quick-test/quick-test.red'
]

gen_test = lambda do |context, x, y| 
    z = context.calc_expected x, y
    test = context.generate_test_name +
           context.set_word('x', x, :to_to_red_money) +
           context.set_word('y', y, :to_to_red_money) +
           context.set_word('z', z, :to_to_red_money) +
           "\t\t" + '--assert z  = (x ' + context.red_fn + ' y)' + "\n\n"
end

gen_comp_test = lambda do |context, x, y|
    z = context.calc_expected x, y
    context.generate_test_name +
    context.set_word('x', x, :to_to_red_money) +
    context.set_word('y', y, :to_to_red_money) +
    context.set_word('z', z) +
    "\t\t" + '--assert z  =  (x ' + context.red_fn + ' y)' + "\n\n"
end

red_operators = [
    RedFunc2Params.new('add', '+', :+.to_proc, gen_test, test_pairs),
    RedFunc2Params.new('subtract', '-', :-.to_proc, gen_test, test_pairs),
    RedFunc2Params.new('multiply', '*', :*.to_proc, gen_test, test_pairs),
    RedFunc2Params.new('divide', '/', :/.to_proc, gen_test, test_pairs),
    RedFunc2Params.new('lesser or equal', '<=', :<=.to_proc, gen_comp_test, test_pairs),
    RedFunc2Params.new('lesser', '<', :<.to_proc, gen_comp_test, test_pairs),
    RedFunc2Params.new('equal', '=', :==.to_proc, gen_comp_test, test_pairs),
    RedFunc2Params.new('not equal', '<>', :!=.to_proc, gen_comp_test, test_pairs),
    RedFunc2Params.new('greater', '>', :>.to_proc, gen_comp_test, test_pairs),
    RedFunc2Params.new('greater or equal', '>=', :>=.to_proc, gen_comp_test, test_pairs)
]

puts RedTest.start_file "money-generated", includes
red_operators.each { |red_op| puts red_op.generate_test_group }
puts RedTest.end_file
