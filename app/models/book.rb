class Book < ApplicationRecord
    belongs_to :user

    validates :name, presence: true 
    validates :author, presence: true 
    validates :price, numericality: { only_integer: true, message: "Picee should not be empty  and only contain numeric value" }    
 end
