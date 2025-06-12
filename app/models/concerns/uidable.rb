module Uidable
  extend ActiveSupport::Concern

  included do
    before_create :generate_uid, if: -> { has_attribute?(:uid) }
  end

  def generate_uid
    self.uid ||= self.class.uid
  end

  def to_param
    has_attribute?(:uid) ? uid : id
  end

  module ClassMethods
    def uids_to_ids(uids)
      where(uid: uids).order(:id).pluck(:id)
    end

    def uids_to_field(uids, field)
      where(uid: uids).pluck(field)
    end

    def ids_to_uids(ids)
      where(id: ids).order(:id).pluck(:uid)
    end

    def uid
      SecureRandom.uuid
    end
  end
end
