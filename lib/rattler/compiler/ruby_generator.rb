require 'rattler/compiler'
require 'stringio'

module Rattler::Compiler

  # A +RubyGenerator+ is used to generate well-formatted ruby code. It keeps
  # track of the indent level and has various methods for adding code, all of
  # which return +self+ to allow method chaining.
  class RubyGenerator

    # Create a new +RubyGenerator+ with the given options, yield it to the
    # block, and return the code generated by the block.
    #
    # @param (see #initialize)
    # @option (see #initialize)
    # @yield [RubyGenerator]
    # @return [String] the code generated by the block
    #
    def self.code(options = {})
      generator = self.new(options)
      yield generator
      generator.code
    end

    # Create a new +RubyGenerator+ with the given options.
    #
    # @option options [Integer] :indent_level (0) the initial indent level
    # @option options [StringIO] :io (StringIO.new) the StringIO object that
    #   the generator will write the generated code to
    #
    def initialize(options = {})
      @indent_level = options[:indent_level] || 0
      @io = options[:io] || StringIO.new
    end

    # Add arbirtrary code.
    #
    # @param [String] s the code to add
    #
    # @return [self]
    def <<(s)
      @io << s
      self
    end

    # Add the appropriate amount of space to indent the start of a line.
    #
    # @return [self]
    def start_line
      @io << ('  ' * @indent_level)
      self
    end

    # Add a line break followed by the appropriate amount of space to indent
    # the start of a line.
    #
    # @return [self]
    def newline
      @io.puts
      start_line
    end

    # Increase the indent level and start a new line for the given block.
    #
    # @return [self]
    def indent
      @indent_level += 1
      newline
      yield
      @indent_level -= 1
      self
    end

    # Append the given string after code generated in the given block.
    #
    # @return [self]
    def suffix(s)
      yield
      self << s
    end

    # Append +before+, followed by the code generated in the given block,
    # followed by +after+.
    #
    # @param [String] before the code to append before the block
    # @param [String] after the code to append after the block
    #
    # @return [self]
    def surround(before, after)
      self << before
      suffix(after) { yield }
    end

    # Generate a multiline indented block with the code generated in the
    # given block, opening the block with +before+ and closing it with
    # +after+.
    #
    # @param [String] before the code to open the block
    # @param [String] after the code to close the block
    #
    # @return [self]
    def block(before, after='end')
      self << before
      indent { yield }
      newline << after
    end

    # Add a separator or newlines or both in between code generated in the
    # given block for each element in +enum+. Newlines, are always added
    # after the separator.
    #
    # @param [Enumerable] enum an enumerable sequence of objects
    #
    # @option opts [String] :sep (nil) optional separator to use between
    #   elements
    # @option opts [true, false] :newline (false) separate with a single
    #   newline if +true+ (and if :newlines is not specified)
    # @option opts [Integer] :newlines (nil) optional number of newlines to
    #   use between elements (overrides :newline)
    #
    # @yield [element] each element in +enum+
    #
    # @return [self]
    def intersperse(enum, opts={})
      sep = opts[:sep]
      newlines = opts[:newlines] || (opts[:newline] ? 1 : 0)
      enum.each_with_index do |_, i|
        if i > 0
          self << sep if sep
          newlines.times { newline }
        end
        yield _
      end
      self
    end

    # Add +sep+ followed by a newline in between code generated in the given
    # block for each element in +enum+.
    #
    # @param [Enumerable] enum an enumerable sequence of objects
    # @yield [element] each element in +enum+
    #
    # @return [self]
    def intersperse_nl(enum, sep)
      intersperse(enum, :sep => sep, :newline => true) {|_| yield _ }
    end

    # Return the generated code.
    #
    # @return [String] the generated code
    def code
      @io.string
    end

  end
end
