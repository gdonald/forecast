require 'rails_helper'

RSpec.describe WeatherForecast, type: :model do
  subject(:weather_forecast) { build(:weather_forecast) }

  it { is_expected.to validate_presence_of(:zip) }

  describe '.for_zip' do
    it 'returns the weather forecast for the given zip' do
      weather_forecast = create(:weather_forecast)
      expect(WeatherForecast.for_zip('12345')).to eq([ weather_forecast ])
    end

    it 'does not return the weather forecast for a different zip' do
      create(:weather_forecast, zip: '12345')
      expect(WeatherForecast.for_zip('54321')).to be_empty
    end

    it 'does not return the weather forecast if it is older than 30 minutes' do
      create(:weather_forecast, zip: '12345', created_at: 31.minutes.ago)
      expect(WeatherForecast.for_zip('12345')).to be_empty
    end

    it 'returns the most recent weather forecast' do
      create(:weather_forecast, zip: '12345', created_at: 31.minutes.ago)
      new_weather_forecast = create(:weather_forecast, zip: '12345')
      expect(WeatherForecast.for_zip('12345')).to eq([ new_weather_forecast ])
    end
  end
end
