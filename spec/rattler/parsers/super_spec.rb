require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Super do
  include CombinatorParserSpecHelper

  subject { Super[:word] }

  let(:rules) { RuleSet.new(:includes => [included_rules]) }

  let(:included_rules) { RuleSet[Rule[:word, Match[/\w+/]]] }

  describe '#parse' do

    context 'when the inherited rule matches' do
      it 'succeeds returns the result' do
        parsing('abc123  ').should result_in('abc123').at(6)
      end
    end

    context 'when the inherited rule fails' do
      it 'fails' do
        parsing('==').should fail
      end
    end
  end

  describe '#capturing?' do
    it 'is true' do
      subject.should be_capturing
    end
  end

  describe '#capturing_decidable?' do
    it 'is false' do
      subject.should_not be_capturing_decidable
    end
  end

  describe '#with_ws' do
    it 'returns self' do
      subject.with_ws(Match[/\s*/]).should == subject
    end
  end

end
