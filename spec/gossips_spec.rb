RSpec.describe Gossips do
  context ".configure" do
    context "sets elasticsearch attributes" do
      let(:unique_index_name) { Time.now.to_i.to_s }

      it "initializes default elasticsearch index name" do
        described_class.configure {}
        expect(Gossips.config.elasticsearch.index).to include('gossips_test')
      end
  
      it "sets different elasticsearch index name" do
        index_name_was = Gossips.config.elasticsearch.index

        described_class.configure do |config|
          config.elasticsearch.index = unique_index_name
        end
  
        expect(Gossips.config.elasticsearch.index).to eq(unique_index_name)
        expect(Gossips::Search::Index.new(name: index_name_was).delete!).to be_truthy
      end

      context ".redis" do
        it "returns instance of a redis class" do
          expect(described_class.redis).to be_instance_of(Redis)
        end
      end
    end
  end
end