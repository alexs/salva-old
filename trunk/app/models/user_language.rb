class UserLanguage < ActiveRecord::Base
  attr_accessor :name

  validates_presence_of :language_id, :spoken_languagelevel_id, :written_languagelevel_id
  validates_numericality_of :language_id, :spoken_languagelevel_id, :written_languagelevel_id

  belongs_to :language
  belongs_to :spoken_languagelevel, :class_name => 'Languagelevel', :foreign_key => 'spoken_languagelevel_id'
  belongs_to :written_languagelevel, :class_name => 'Languagelevel', :foreign_key => 'written_languagelevel_id'
end