# Class MoviesController
class MoviesController < ApplicationController
  helper_method :sort_column
  helper_method :highlight
  helper_method :chosen_rating?

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
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
    if !params[:ratings].nil?
      array_ratings = params[:ratings].keys
      @movies = Movie.where(rating: array_ratings).order(sort_column)
    else
      @movies = Movie.order(sort_column)
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

  def sort_column
    Movie.column_names.include?(params[:sort]) ? params[:sort] : 'title'
  end

  def highlight(column)
    'highlight' if sort_column == column
  end

  def chosen_rating?(rating)
    chosen_ratings = session[:ratings]
    return true if chosen_ratings.nil?
    chosen_ratings.include? rating
  end

end
