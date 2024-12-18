class CreateWeatherForecasts < ActiveRecord::Migration[8.0]
  def change
    create_table :weather_forecasts do |t|
      t.string :zip
      t.text :data
      t.timestamps
    end
    add_index :weather_forecasts, %i[zip created_at]
  end
end
