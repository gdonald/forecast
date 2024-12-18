class WeatherForecast < ApplicationRecord
  validates :zip, presence: true

  scope :for_zip, ->(zip) do
    where(zip:)
      .where("created_at > ?", 30.minutes.ago)
      .order(created_at: :desc)
  end
end
