# frozen_string_literal: true

# Fix an issue with `LIMIT` ocurring on the left side of a `UNION` causing syntax errors.
# See https://github.com/rails/rails/issues/40181

# rubocop:disable all -- This is a mostly vendored file

module Arel
  module Visitors
    class ToSql
      private

        def infix_value_with_paren(o, collector, value, suppress_parens = false)
          collector << "( " unless suppress_parens
          collector = if o.left.class == o.class
            infix_value_with_paren(o.left, collector, value, true)
          else
            collector << "( " unless suppress_parens # Added
            visit o.left, collector
            collector << " )" unless suppress_parens # Added
            collector # Added
          end
          collector << value
          collector = if o.right.class == o.class
            infix_value_with_paren(o.right, collector, value, true)
          else
            collector << "( " unless suppress_parens # Added
            visit o.right, collector
            collector << " )" unless suppress_parens # Added
            collector # Added
          end
          collector << " )" unless suppress_parens
          collector
        end
    end
  end
end

# rubocop:enable all
