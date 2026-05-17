class RedirectsController < ApplicationController
  def show
    @url = Url.find_by!(short_code: params[:short_code])
    @url.increment!(:clicks_count)
    redirect_to @url.original_url, allow_other_host: true
  end
end
