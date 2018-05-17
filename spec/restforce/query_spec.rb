RSpec.describe Restforce::Query do
  let(:restforce_client) { Restforce::Client.new }
  it 'has a version number' do
    expect(Restforce::Query::VERSION).not_to be nil
  end

  it 'is Enumerable' do
    allow(restforce_client)
      .to(receive(:query))
      .and_return([1] * 10)
    subject = Restforce::Query.new(double('builder'), restforce_client)
    expect(subject.count).to eq(10)
  end
end
