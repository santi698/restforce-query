require 'spec_helper'

RSpec.describe Restforce::Query::WhereRenderer do
  subject { described_class }
  describe 'render' do
    context 'when given only a custom condition' do
      it 'renders correctly' do
        expected = ' WHERE AccountId NOT IN (\'2\', \'1\')'
        expect(subject.render(['AccountId NOT IN (\'2\', \'1\')'], nil))
          .to eq expected
      end
    end

    context 'when given a standard condition with a single value String' do
      it 'renders correctly' do
        expected = ' WHERE Id = \'12345\''
        expect(subject.render(nil, Id: '12345')).to eq expected
      end
    end

    context 'when given a standard condition with a single value Float' do
      it 'renders correctly' do
        expected = ' WHERE Amount = 290.0'
        expect(subject.render(nil, Amount: 290.0)).to eq expected
      end
    end

    context 'when given a standard condition with lists' do
      it 'renders correctly' do
        expected = ' WHERE Id IN (\'12345\',\'23456\')'
        expect(subject.render(nil, Id: %w[12345 23456])).to eq expected
      end
    end

    context 'when given both custom and standard conditions' do
      it 'renders correctly' do
        expected = ' WHERE StageName NOT IN (\'Closed Won\', \'Alta\') AND Id = \'12345\''
        custom_condition = 'StageName NOT IN (\'Closed Won\', \'Alta\')'
        expect(subject.render([custom_condition], Id: '12345')).to eq expected
      end
    end

    context 'when multiple custom conditions' do
      it 'renders correctly' do
        expected = ' WHERE Id NOT IN (\'1\',\'2\') AND AccountId != \'3\''
        condition1 = 'Id NOT IN (\'1\',\'2\')'
        condition2 = 'AccountId != \'3\''
        expect(subject.render([condition1, condition2], nil)).to eq expected
      end
    end
  end
end
