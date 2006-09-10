class Schooling < ActiveRecord::Base
  validates_presence_of :institutioncareer_id, :credential_id, :startyear
  # :titleholder
  validates_numericality_of :institutioncareer_id, :credential_id
  belongs_to :credential
  belongs_to :institutioncareer
end
