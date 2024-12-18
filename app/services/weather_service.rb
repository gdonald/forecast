class WeatherService
  attr_accessor :api_key

  WIND_DIRECTIONS = %w[North NorthEast East SouthEast South SouthWest West NorthWest].freeze

  def initialize(api_key: ENV["WEATHER_API_KEY"])
    @api_key = api_key
  end

  def get_forecast(zip)
    forecast = WeatherForecast.for_zip(zip).first
    return JSON.parse(forecast.data).merge("created_at" => forecast.created_at.to_fs) if forecast

    url = "https://api.openweathermap.org/data/2.5/weather?zip=#{zip}&units=imperial&appid=#{api_key}"
    response = HTTParty.get(url)

    if response.code == 200
      forecast = cache_response(zip:, data: response.body)
      JSON.parse(forecast.data)
    else
      { "error" => "Unable to fetch weather forecast" }
    end
  end

  private

  def cache_response(zip:, data:)
    data = parse_response_data(data)
    WeatherForecast.create(zip:, data:)
  end

  def parse_response_data(data)
    json = JSON.parse(data)
    description = json["weather"].first["description"]

    main = json["main"]
    current_temp = main["temp"].to_i
    feels_like = main["feels_like"].to_i
    temp_min = main["temp_min"].to_i
    temp_max = main["temp_max"].to_i
    humidity = main["humidity"]

    wind = json["wind"]
    wind_speed = wind["speed"].to_i
    wind_direction = degrees_to_direction(wind["deg"])

    {
      description:,
      current_temp:,
      feels_like:,
      temp_min:,
      temp_max:,
      humidity:,
      wind_speed:,
      wind_direction:
    }.to_json
  end

  def degrees_to_direction(degrees)
    # align degrees on a possible direction
    index = ((degrees + 22.5) / 45).floor % 8

    WIND_DIRECTIONS[index]
  end
end
