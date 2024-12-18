class WeatherForecast < ApplicationRecord
  scope :for_zip, ->(zip) { where(zip:).where("created_at > ?", 30.minutes.ago) }
end
