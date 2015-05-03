class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @entry = current_user.entries.new
  end
end
