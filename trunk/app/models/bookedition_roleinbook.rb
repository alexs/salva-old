class BookeditionRoleinbook < ActiveRecord::Base
#  validates_presence_of :bookedition_id, :message => "Proporcione el bookedition_id"
  validates_presence_of :roleinbook_id, :message => "Proporcione el roleinbook_id"
  validates_presence_of :user_id, :message => "Proporcione el user_id"
  
  belongs_to :bookedition
  belongs_to :roleinbook
  belongs_to :user
end