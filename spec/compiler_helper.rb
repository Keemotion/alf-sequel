require_relative 'spec_helper'

module CompilerHelpers
  include Alf::Lang::Functional

  def var_ref(name, ctx = _context)
    Alf::Operator::VarRef.new(ctx, name)
  end

  def _context
    sap
  end

  def an_operand
    Alf::Tools::FakeOperand.new(sap)
  end

  def compile(expr)
    Alf::Sequel::Compiler.new(sap).call(expr)
  end

end

RSpec.configure do |c|
  c.include CompilerHelpers
end