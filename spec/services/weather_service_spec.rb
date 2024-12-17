require 'rails_helper'

RSpec.describe WeatherService, type: :service do
  subject(:service) { described_class.new(api_key: 'api-key') }

  describe '#get_forecast' do
    context 'when a forecast is cached' do
      before do
        create(:weather_forecast, zip: '12345')
      end

      it 'returns the cached forecast' do
        allow(HTTParty).to receive(:get)
        result = service.get_forecast('12345')
        expect(result['description']).to eq('clear sky')
        expect(HTTParty).to_not have_received(:get)
      end
    end

    context 'when a forecast is not cached' do
      let(:body) { file_fixture('weather_response.json').read }

      before do
        stub_request(:get, "https://api.openweathermap.org/data/2.5/weather?appid=api-key&units=imperial&zip=12345").
          with(
            headers: {
              'Accept' => '*/*',
              'User-Agent' => 'Ruby'
            }).
          to_return(status: 200, body: body, headers: {})
      end

      it 'makes an http request' do
        result = service.get_forecast('12345')
        expect(result['description']).to eq('moderate rain')
        expect(result['wind_direction']).to eq('SouthWest')
      end

      context 'when the request fails' do
        before do
          stub_request(:get, "https://api.openweathermap.org/data/2.5/weather?appid=api-key&units=imperial&zip=12345").
            with(
              headers: {
                'Accept' => '*/*',
                'User-Agent' => 'Ruby'
              }).
            to_return(status: 500, body: "", headers: {})
        end

        it 'returns an error' do
          result = service.get_forecast('12345')
          expect(result['error']).to eq('Unable to fetch weather forecast')
        end
      end
    end
  end
end
