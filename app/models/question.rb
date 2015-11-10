class Question < ActiveRecord::Base

has_many :answers, dependent: :destroy
belongs_to :user


validates(:title, {presence: true, uniqueness: true, length: {minimum: 3}})
# validates(:title, {presence: true, uniqueness: {message: "was used already"}})
validates :body, presence: true, uniqueness: {scope: :title}
                # scope is a method in rails that takes 2 arguements
                #scope :recent_ten, lambda {order("created_at DESC").limit(10)}
                # uniqueness: scope: :title
                # using scope: :title will make sure that the body is unique
                # in combination with the title. MEANS: Within the scope of a title
                # make sure that body is unique

validates :view_count, numericality: {greater_than_or_equal_to: 0}
# validates :view_count, numericality: true


# This is a CUSTOM VALIDATION METHOD:
validate :no_monkey

after_initialize :set_default_values

before_validation :capitalize_title

# scope(:recent_ten, lambda { order("created_at DESC").limit(10) })
def self.recent_ten
  order("created_at DESC").limit(10)
end

def self.recent(num_records)
  order("created_at DESC").limit(num_records)
end

def self.search(term)
  if term == ""
  "You must enter a search term"
  else
  where(["title ILIKE? OR body ILIKE?", "%#{term}%", "%#{term}%"])
  end
end
  # where(["title ILIKE :search_term OR body ILIKE  :search_term", {search_term: "%#{string}%"}])




private
# this is a custom validation method
  def no_monkey
    if title.present? && title.downcase.include?("monkey")
      errors.add(:title, "No monkeys please!")
    end
  end

  def set_default_values
    self.view_count ||= 0
  end

  def capitalize_title
    self.title.capitalize! if title
  end

end
