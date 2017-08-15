class HomeController < ApplicationController
  def home
      if logged_in?
          @micropost  = current_user.microposts.build
          # @feed_items = current_user.feed.paginate(page: params[:page])
          @feed_items = Micropost.all.paginate(page: params[:page])
      end
  end
end
