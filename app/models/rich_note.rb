class RichNote < ApplicationRecord
  has_one :note, as: :entity
  
  has_rich_text :content
end
