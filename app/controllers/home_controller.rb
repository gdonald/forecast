class HomeController < ApplicationController
  def index
  end

  def update
    service = WeatherService.new
    forecast = service.get_forecast(params[:address][:zip])

    respond_to do |format|
      format.html { render :index, status: 422 }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(:forecast, partial: "forecast", locals: { forecast: })
      end
    end
  end
end
