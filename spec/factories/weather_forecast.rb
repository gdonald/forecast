FactoryBot.define do
  factory :weather_forecast do
    zip { '12345' }
    data do
      {
        description: 'clear sky',
        current_temp: 75,
        feels_like: 74,
        temp_min: 70,
        temp_max: 78,
        humidity: 60,
        wind_speed: 5,
        wind_direction: 80
      }.to_json
    end
  end
end
