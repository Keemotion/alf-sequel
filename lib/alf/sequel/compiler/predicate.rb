module Alf
  module Sequel
    class Compiler
      class Predicate < Sexpr::Processor

        def call(predicate)
          super(predicate.expr)
        end

        def on_missing(sexpr)
          throw :pass
        end
        alias :on_native :on_missing

        def on_tautology(sexpr)
          ::Sequel::SQL::BooleanConstant.new(true)
        end

        def on_contradiction(sexpr)
          ::Sequel::SQL::BooleanConstant.new(false)
        end

        def on_sequel_expr(sexpr)
          ::Sequel.expr(sexpr.last)
        end
        alias :on_var_ref :on_sequel_expr
        alias :on_literal :on_sequel_expr

        def on_eq(sexpr)
          left, right = apply(sexpr.left), apply(sexpr.right)
          ::Sequel.expr(left => right)
        end

        def on_dyadic_comp(sexpr)
          left, right = apply(sexpr.left), apply(sexpr.right)
          left.send(sexpr.operator_symbol, right)
        end
        alias :on_neq :on_dyadic_comp
        alias :on_lt  :on_dyadic_comp
        alias :on_lte :on_dyadic_comp
        alias :on_gt  :on_dyadic_comp
        alias :on_gte :on_dyadic_comp

        def on_in(sexpr)
          left = apply(sexpr.var_ref)
          ::Sequel.expr(left => sexpr.values)
        end

        def on_not(sexpr)
          ~apply(sexpr.last)
        end

        def on_and(sexpr)
          body = sexpr.sexpr_body
          body[1..-1].inject(apply(body.first)){|f,t| f & apply(t) }
        end

        def on_or(sexpr)
          body = sexpr.sexpr_body
          body[1..-1].inject(apply(body.first)){|f,t| f | apply(t) }
        end

      end # class Predicate
    end # class Compiler
  end # module Sequel
end # module Alf