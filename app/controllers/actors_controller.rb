class ActorsController < ApplicationController
    def index
      if params[:actor].present?
        @actors = Actor.where('LOWER(name) LIKE ?', "%#{params[:actor].downcase}%").paginate(page: params[:page], per_page: 10)
      else
        @actors = Actor.all.paginate(page: params[:page], per_page: 10)
      end
    end
  end