class Day < ApplicationRecord
	has_many :matchs, dependent: :destroy
	validates :name, uniqueness: true
end
