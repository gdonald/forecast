require 'rails_helper'

RSpec.describe 'Get Weather Forecast', type: :system do
  let(:body) { file_fixture('weather_response.json').read }

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('WEATHER_API_KEY').and_return('api-key')

    stub_request(:get, "https://api.openweathermap.org/data/2.5/weather?appid=api-key&units=imperial&zip=37043").
    with(
      headers: {
        'Accept' => '*/*',
        'User-Agent' => 'Ruby'
      }).
    to_return(status: 200, body: body, headers: {})
  end

  it 'can request weather forecast by zip code' do
    visit root_path

    expect(page).to have_css('h1', text: 'Get Forecast')

    fill_in('Zip', with: '37043')
    click_on('Submit')

    within '#forecast' do
      expect(page).to have_css('h2', text: 'Latest Forecast')
      expect(page).to have_css('p', text: 'SouthWest at 9mph')
      expect(page).to_not have_css('p', text: '* Cached At')
    end
  end

  context 'with a cached forecast' do
    before do
      create(:weather_forecast, zip: '37043')
    end

    it 'can display the cached forecast' do
      visit root_path

      fill_in('Zip', with: '37043')
      click_on('Submit')

      within '#forecast' do
        expect(page).to have_css('p', text: '* Cached At')
      end
    end
  end
end
