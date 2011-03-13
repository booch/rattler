require 'rattler/back_end/parser_generator'

module Rattler::BackEnd::ParserGenerator

  # @private
  class DisallowGenerator < ExprGenerator #:nodoc:

    def gen_basic(disallow, scope={})
      generate disallow.child, :disallow, scope
    end

    def gen_assert(disallow, scope={})
      @g << 'false'
    end

    def gen_disallow(disallow, scope={})
      gen_basic disallow, scope
    end

    def gen_skip_nested(disallow, scope={})
      gen_basic_nested disallow, scope
    end

    def gen_skip_top_level(disallow, scope={})
      gen_basic_top_level disallow, scope
    end

    def gen_dispatch_action_nested(disallow, code, scope={})
      atomic_block { gen_dispatch_action_top_level disallow, code, scope }
    end

    def gen_dispatch_action_top_level(disallow, code, scope={})
      gen_action disallow, code.bind(scope, '[]'), scope
    end

    def gen_direct_action_nested(disallow, code, scope={})
      atomic_block { gen_direct_action_top_level disallow, code, scope }
    end

    def gen_direct_action_top_level(disallow, code, scope={})
      gen_action disallow, "(#{code.bind scope, []})", scope
    end

    def gen_token_nested(disallow, scope={})
      atomic_block { gen_token_top_level disallow, scope }
    end

    def gen_token_top_level(disallow, scope={})
      gen_action disallow, "''", scope
    end

    def gen_intermediate(disallow, scope={})
      generate disallow.child, :intermediate_disallow, scope
    end

    def gen_intermediate_disallow(disallow, scope={})
      gen_intermediate disallow, scope
    end

    def gen_intermediate_skip(disallow, scope={})
      gen_intermediate disallow, scope
    end

    private

    def gen_action(disallow, result_code, scope={})
      gen_intermediate disallow, scope
      (@g << ' &&').newline << result_code
    end

  end

  # @private
  class NestedDisallowGenerator < DisallowGenerator #:nodoc:
    include Nested
    include NestedSubGenerating
  end

  def DisallowGenerator.nested(*args)
    NestedDisallowGenerator.new(*args)
  end

  # @private
  class TopLevelDisallowGenerator < DisallowGenerator #:nodoc:
    include TopLevel
    include TopLevelSubGenerating
  end

  def DisallowGenerator.top_level(*args)
    TopLevelDisallowGenerator.new(*args)
  end

end
