class RedirectsController < ApplicationController
  def show
    @url = Url.find_by!(short_code: params[:short_code])
    @url.increment!(:clicks_count)

    uri = URI.parse(@url.original_url)
    raise ActionController::RoutingError, "Invalid redirect" unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)

    redirect_to @url.original_url, allow_other_host: true
  end
end
