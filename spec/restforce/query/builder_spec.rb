require 'spec_helper'

RSpec.describe Restforce::Query::Builder do
  describe '#render' do
    context 'when no fields are passed to select' do
      it 'raises an error' do
        expect { subject.render }
          .to raise_error('There must be at least one field in the SELECT clause')
      end
    end
    context 'when no table is passed to from' do
      it 'raises an error' do
        expect { subject.select('Id').render }
          .to raise_error('There must be at least one table in the FROM clause')
      end
    end

    context 'when given a simple query' do
      it 'renders correctly' do
        expected = 'SELECT Id FROM Opportunity'
        expect(subject.select('Id').from('Opportunity').render).to eq expected
      end
    end

    context 'when given a simple query with a condition' do
      it 'renders correctly' do
        expected = 'SELECT Id FROM Opportunity WHERE StageName = \'Alta\''
        query = subject.select('Id').from('Opportunity').where(StageName: 'Alta')
        expect(query.render).to eq expected
      end
    end

    context 'when given a simple query with a limit' do
      it 'renders correctly' do
        expected = 'SELECT Id FROM Opportunity LIMIT 1'
        query = subject.select('Id').from('Opportunity').limit(1)
        expect(query.render).to eq expected
      end
    end

    context 'when given a simple query with a GROUP BY clause' do
      it 'renders correctly' do
        expected = 'SELECT COUNT(Id) FROM Opportunity GROUP BY StageName'
        query = subject.select('COUNT(Id)').from('Opportunity').group_by('StageName')
        expect(query.render).to eq expected
      end
    end
  end
end
