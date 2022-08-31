class User < ApplicationRecord
  has_many :books
  has_many :boughts

  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         jwt_revocation_strategy: JwtDenylist

         enum role:[:client,:admin]
         
         VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
        #  validates email  but does not show validates email messages because use of devise in session controller
         validates :email, presence: true,
                        length: {minimum: 5, maxmimum: 105},
                        uniqueness: {case_sensitive: false},
                        format: { with: VALID_EMAIL_REGEX }
        #  validates :password,presence: true 

   after_initialize :set_default_role, :if => :new_record?
   def set_default_role # set default role  if no role is given
    self.role ||= :client    
   end
end
