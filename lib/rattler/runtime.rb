require 'rattler'

module Rattler
  # The +Runtime+ module defines the classes used by concrete parsers.
  module Runtime
    autoload :Parser, 'rattler/runtime/parser'
    autoload :RecursiveDescentParser, 'rattler/runtime/recursive_descent_parser'
    autoload :PackratParser, 'rattler/runtime/packrat_parser'
    autoload :ExtendedPackratParser, 'rattler/runtime/extended_packrat_parser'
    autoload :ParseNode, 'rattler/runtime/parse_node'
    autoload :ParserHelper, 'rattler/runtime/parser_helper'
    autoload :ParseFailure, 'rattler/runtime/parse_failure'
    autoload :SyntaxError, 'rattler/runtime/syntax_error'
  end
end
