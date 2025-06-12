require 'rails_helper'

RSpec.describe Uidable do
  describe "callbacks" do
    it "generates a uid before create" do
      user = build(:user)
      expect(user.uid).to be_nil
      user.save!
      expect(user.uid).to be_present
      expect(user.uid).to match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/)
    end

    it "does not generate a uid if one is already present" do
      existing_uid = SecureRandom.uuid
      user = build(:user, uid: existing_uid)
      user.save!
      expect(user.uid).to eq(existing_uid)
    end

    it "does not generate a uid if the model doesn't have a uid attribute" do
      model = Class.new do
        include ActiveRecord::Callbacks
        include Uidable
        attr_accessor :uid
        def save!; end
        def self.before_create(*args); end
        def has_attribute?(_); false; end
      end.new
      expect { model.send(:generate_uid) }.not_to raise_error
    end
  end

  describe "class methods" do
    let!(:records) { create_list(:user, 3) }
    let(:uids) { records.map(&:uid) }
    let(:ids) { records.map(&:id) }

    describe ".uids_to_ids" do
      it "converts uids to ids" do
        expect(User.uids_to_ids(uids)).to match_array(ids)
      end

      it "returns empty array for empty input" do
        expect(User.uids_to_ids([])).to eq([])
      end

      it "returns empty array for non-existent uids" do
        expect(User.uids_to_ids(['non-existent'])).to eq([])
      end
    end

    describe ".uids_to_field" do
      it "converts uids to specified field values" do
        expect(User.uids_to_field(uids, :email)).to match_array(records.map(&:email))
      end

      it "returns empty array for empty input" do
        expect(User.uids_to_field([], :email)).to eq([])
      end

      it "returns empty array for non-existent uids" do
        expect(User.uids_to_field(['non-existent'], :email)).to eq([])
      end
    end

    describe ".ids_to_uids" do
      it "converts ids to uids" do
        expect(User.ids_to_uids(ids)).to match_array(uids)
      end

      it "returns empty array for empty input" do
        expect(User.ids_to_uids([])).to eq([])
      end

      it "returns empty array for non-existent ids" do
        expect(User.ids_to_uids([999999])).to eq([])
      end
    end

    describe ".uid" do
      it "generates a UUID" do
        expect(User.uid).to match(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/)
      end

      it "generates unique UUIDs" do
        uids = 100.times.map { User.uid }
        expect(uids.uniq).to eq(uids)
      end
    end
  end

  describe "instance methods" do
    let(:record) { create(:user) }

    describe "#to_param" do
      it "returns the uid" do
        expect(record.to_param).to eq(record.uid)
      end

      it "returns the id if uid attribute is not present" do
        model = Class.new do
          include ActiveRecord::Callbacks
          include Uidable
          attr_reader :id
          attr_accessor :uid
          def initialize(id)
            @id = id
          end
          def has_attribute?(_); false; end
          def self.before_create(*args); end
        end.new(123)
        expect(model.to_param).to eq(123)
      end
    end
  end
end
