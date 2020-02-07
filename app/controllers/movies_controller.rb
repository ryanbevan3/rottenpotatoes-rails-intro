# Class MoviesController
class MoviesController < ApplicationController
  helper_method :highlight
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = %w[G PG PG-13 R]

    # use sessions and params to remember what the user previously selected
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
    end
    if !params[:order].nil?
      session[:order] = params[:order]
    end

    # create variables to test the state of sessions and parameters
    new_rating_param = !params[:ratings].nil?
    new_order_param = !params[:order].nil?
    session_order = !session[:order].nil?
    session_rating = !session[:ratings].nil?

    # if no new params and existing session, pick up where the user left off. If no session as well, load all movies
    if !new_rating_param && !new_order_param
      if session_rating
        redirect_to movies_path('ratings': session[:ratings], 'order': session[:order])
      elsif session_order
        redirect_to movies_path('order': session[:order])
      else
        @movies = Movie.all
      end

      # if new param for rating, update with new rating and existing order
    elsif new_rating_param
      @movies = Movie.where(rating: params[:ratings].keys).order(session[:order])

      # load new order with existing rating
    elsif session_rating || session_order
      redirect_to movies_path('ratings': session[:ratings], 'order': session[:order])
    else
      @movies = Movie.all.order(session[:order])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def highlight(column)
    'highlight' if session[:order].to_s == column
  end
end
