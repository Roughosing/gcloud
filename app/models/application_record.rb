class ApplicationRecord < ActiveRecord::Base
  include Uidable

  primary_abstract_class
end
