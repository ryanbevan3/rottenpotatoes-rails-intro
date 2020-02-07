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
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
    session[:order] = params[:order] unless params[:order].nil?

    if params[:ratings].nil? || params[:order].nil?
      if !session[:ratings].nil? && !session[:order].nil?
        redirect_to movies_path('ratings' => session[:ratings], 'order' => session[:order])
      end
    elsif (@movies = if !params[:ratings].nil?
                       Movie.where(rating: params[:ratings].keys).order(session[:order])
                     elsif !params[:order].nil?
                       Movie.all.order(session[:order])
                     else
                       @movies = Movie.all
                     end)
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
