require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

include Rattler::Compiler::ParserGenerator
include Rattler::Parsers

describe AssertGenerator do

  include ParserGeneratorSpecHelper

  let(:assert) { Assert[Match[/\d/]] }

  describe '#gen_basic' do

    context 'when nested' do
      it 'generates nested positive lookahead code' do
        nested_code {|g| g.gen_basic assert }.
          should == '(@scanner.skip(/(?=\d)/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level positive lookahead code' do
        top_level_code {|g| g.gen_basic assert }.
          should == '@scanner.skip(/(?=\d)/) && true'
      end
    end
  end

  describe '#gen_assert' do

    context 'when nested' do
      it 'generates nested positive lookahead code' do
        nested_code {|g| g.gen_assert assert }.
          should == '(@scanner.skip(/(?=\d)/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level positive lookahead code' do
        top_level_code {|g| g.gen_assert assert }.
          should == '@scanner.skip(/(?=\d)/) && true'
      end
    end
  end

  describe '#gen_disallow' do

    context 'when nested' do
      it 'generates "false"' do
        nested_code {|g| g.gen_disallow assert }.should == 'false'
      end
    end

    context 'when top-level' do
      it 'generates "false"' do
        top_level_code {|g| g.gen_disallow assert }.should == 'false'
      end
    end
  end

  describe '#gen_token' do

    context 'when nested' do
      it 'generates nested positive lookahead and empty string string code' do
        nested_code {|g| g.gen_token assert }.
          should == (<<-CODE).strip
begin
  @scanner.skip(/(?=\\d)/) &&
  ''
end
          CODE
      end
    end

    context 'when top-level' do
      it 'generates top-level positive lookahead and empty string string code' do
        top_level_code {|g| g.gen_token assert }.
          should == (<<-CODE).strip
@scanner.skip(/(?=\\d)/) &&
''
          CODE
      end
    end
  end

  describe '#gen_skip' do

    context 'when nested' do
      it 'generates nested positive lookahead code' do
        nested_code {|g| g.gen_skip assert }.
          should == '(@scanner.skip(/(?=\d)/) && true)'
      end
    end

    context 'when top-level' do
      it 'generates top level positive lookahead code' do
        top_level_code {|g| g.gen_skip assert }.
          should == '@scanner.skip(/(?=\d)/) && true'
      end
    end
  end

  describe '#gen_intermediate' do
    it 'generates intermediate positive lookahead code' do
      nested_code {|g| g.gen_intermediate assert }.
        should == '@scanner.skip(/(?=\d)/)'
    end
  end

  describe '#gen_intermediate_assert' do
    it 'generates intermediate positive lookahead code' do
      nested_code {|g| g.gen_intermediate_assert assert }.
        should == '@scanner.skip(/(?=\d)/)'
    end
  end

  describe '#gen_intermediate_disallow' do
    it 'generates "false"' do
      nested_code {|g| g.gen_intermediate_disallow assert }.should == 'false'
    end
  end

  describe '#gen_intermediate_skip' do
    it 'generates intermediate positive lookahead code' do
      nested_code {|g| g.gen_intermediate_skip assert }.
        should == '@scanner.skip(/(?=\d)/)'
    end
  end

end
