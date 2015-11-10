class WelcomeController < ApplicationController

# we call a method defined within the controller: action
  def index

  end

  def hello
    # render ({text: "hello World"})
    # or render text: "hello World"
    # render (:hello, {layout: "application"}) This is not needed as Rails does it by default.
  end

  def greeting
    @name = params[:name]
  end

end
