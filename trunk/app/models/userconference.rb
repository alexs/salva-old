class Userconference < ActiveRecord::Base
validates_presence_of :conference_id
validates_numericality_of :conference_id
belongs_to :conference
end