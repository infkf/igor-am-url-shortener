class UrlsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @urls = Url.order(created_at: :desc)
  end

  def new
    @url = Url.new
  end

  def create
    @url = Url.new(url_params)
    if @url.save
      redirect_to urls_path, notice: "URL successfully shortened!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url, :short_code)
  end

  def authenticate_admin!
    username = ENV.fetch('ADMIN_USERNAME', 'admin')
    password = ENV.fetch('ADMIN_PASSWORD', 'password')

    authenticate_or_request_with_http_basic("Admin Area") do |u, p|
      u == username && p == password
    end
  end
end
