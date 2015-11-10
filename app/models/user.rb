class User < ActiveRecord::Base

  has_secure_password

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy


  validates :email, presence: true, uniqueness: true

  def full_name
    "#{first_name} #{last_name}".strip
  end

end
