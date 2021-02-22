class Campaign < ApplicationRecord
  belongs_to :user

  validates :title,     presence: true
  validates :purpose,   presence: true
  validates_presence_of :starts_on, :ends_on
  validate :end_date_is_after_start_date


  private

  def end_date_is_after_start_date
    return if ends_on.blank? || starts_on.blank?
    if ends_on < starts_on
      errors.add(:ends_on, "cannot be before the start date")
    elsif ((ends_on - starts_on).to_i/1.day) > 90
      errors.add(:ends_on, "cannot be more than 3 months from the start date")
    end
  end

end
