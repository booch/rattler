require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::BackEnd::ParserGenerator
include Rattler::Parsers

describe DirectActionGenerator do

  include ParserGeneratorSpecHelper

  let(:action) { DirectAction[Match[/\w+/], '|_| _.to_sym'] }

  describe '#gen_basic' do

    context 'when nested' do
      it 'generates nested matching code with a direct action' do
        nested_code {|g| g.gen_basic action }.
          should == (<<-CODE).strip
begin
  (r = @scanner.scan(/\\w+/)) &&
  (r.to_sym)
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level matching code with a direct action' do
        top_level_code {|g| g.gen_basic action }.
          should == (<<-CODE).strip
(r = @scanner.scan(/\\w+/)) &&
(r.to_sym)
          CODE
      end
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates nested positive lookahead code' do
        nested_code {|g| g.gen_assert action }.
          should == '(@scanner.skip(/(?=\w+)/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level positive lookahead code' do
        top_level_code {|g| g.gen_assert action }.
          should == '@scanner.skip(/(?=\w+)/) && true'
      end
    end
  end

  describe '#gen_disallow' do

    context 'when nested' do
      it 'generates nested negative lookahead code' do
        nested_code {|g| g.gen_disallow action }.
          should == '(@scanner.skip(/(?!\w+)/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level negative lookahead code' do
        top_level_code {|g| g.gen_disallow action }.
          should == '@scanner.skip(/(?!\w+)/) && true'
      end
    end
  end

  describe '#gen_dispatch_action' do

    let(:code) { NodeCode.new('Word', 'parsed') }

    context 'when nested' do
      it 'generates nested matching code with a direct action and a dispatch action' do
        nested_code {|g| g.gen_dispatch_action action, code }.
          should == (<<-CODE).strip
begin
  (r = begin
    (r = @scanner.scan(/\\w+/)) &&
    (r.to_sym)
  end) &&
  Word.parsed([r])
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level matching code with a direct action and a dispatch action' do
        top_level_code {|g| g.gen_dispatch_action action, code }.
          should == (<<-CODE).strip
(r = begin
  (r = @scanner.scan(/\\w+/)) &&
  (r.to_sym)
end) &&
Word.parsed([r])
          CODE
      end
    end
  end

  describe '#gen_direct_action' do

    let(:code) { ActionCode.new('|_| _.size') }

    context 'when nested' do
      it 'generates nested matching code with nested direct actions' do
        nested_code {|g| g.gen_direct_action action, code }.
          should == (<<-CODE).strip
begin
  (r = begin
    (r = @scanner.scan(/\\w+/)) &&
    (r.to_sym)
  end) &&
  (r.size)
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top level matching code with nested direct actions' do
        top_level_code {|g| g.gen_direct_action action, code }.
          should == (<<-CODE).strip
(r = begin
  (r = @scanner.scan(/\\w+/)) &&
  (r.to_sym)
end) &&
(r.size)
          CODE
      end
    end
  end

  describe '#gen_token' do

    context 'when nested' do
      it 'generates nested token matching code' do
        nested_code {|g| g.gen_token action }.
          should == '@scanner.scan(/\w+/)'
      end
    end

    context 'when top-level' do
      it 'generates top level token matching code' do
        top_level_code {|g| g.gen_token action }.
          should == '@scanner.scan(/\w+/)'
      end
    end
  end

  describe '#gen_skip' do

    context 'when nested' do
      it 'generates nested skipping code' do
        nested_code {|g| g.gen_skip action }.
          should == '(@scanner.skip(/\w+/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level skipping code' do
        top_level_code {|g| g.gen_skip action }.
          should == '@scanner.skip(/\w+/) && true'
      end
    end
  end

  describe '#gen_intermediate' do
    it 'generates nested matching code with a direct action' do
      nested_code {|g| g.gen_intermediate action }.
        should == (<<-CODE).strip
begin
  (r = @scanner.scan(/\\w+/)) &&
  (r.to_sym)
end
        CODE
    end
  end

  describe '#gen_intermediate_assert' do
    it 'generates intermediate positive lookahead code' do
      nested_code {|g| g.gen_intermediate_assert action }.
        should == '@scanner.skip(/(?=\w+)/)'
    end
  end

  describe '#gen_intermediate_disallow' do
    it 'generates intermediate negative lookahead code' do
      nested_code {|g| g.gen_intermediate_disallow action }.
        should == '@scanner.skip(/(?!\w+)/)'
    end
  end

  describe '#gen_intermediate_skip' do
    it 'generates intermediate skipping code' do
      nested_code {|g| g.gen_intermediate_skip action }.
        should == '@scanner.skip(/\w+/)'
    end
  end

end
