require 'rails_helper'
require 'monkeyPatch'
require 'simplecov'
SimpleCov.start 'rails'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

# # then, whenever you need to clean the DB
DatabaseCleaner.clean

RSpec.describe MoviesController, type: :controller do
    
    
    describe "#index" do
        it "view all the movies" do
            movie1 = Movie.create(title: 'movie1', director: 'director1', rating:'G', release_date: '2021-00-01')
            movie2 = Movie.create(title: 'movie2', director: 'director2', rating:'R', release_date: '2021-00-02')
            get :index
            expect(assigns(:movies)).to eq [movie1, movie2]
        end
    end

    describe "#view" do
        it "view movie info" do
            movie0 = Movie.create(title: 'movie0', director: 'director0', rating:'G', release_date: '2021-01-01')
            get :show, id: movie0.id
            expect(response).to render_template :show
        end
    end

    describe "#new" do
        it "creating new movie" do
            get :new
            expect(response).to render_template :new
        end
    end
    
    describe "#edit" do
        it "editing existing movie" do
            movie0 = Movie.create(title: 'movie0', director: 'director0', rating:'G', release_date: '2021-01-01')
            get :edit, id: movie0.id
            expect(response).to render_template :edit
        end
    end
    
    describe "#update" do
        it "updating existing movie" do
            movie0 = Movie.create(title: 'movie', director: 'director', rating:'G', release_date: '2021-00-00')
            put :update, id: movie0.id, movie: {title: 'movie', director: 'director', rating:'R', release_date: '2021-04-01'}
            movie0.reload
            expect(movie0.title).to eq('movie')
            expect(movie0.director).to eq('director')
            expect(movie0.rating).to eq('R')
            expect(movie0.release_date).to eq('2021-04-01')
            expect(flash[:notice]).to eq("#{movie0.title} was successfully updated.")
            expect(response).to redirect_to(movie0)
        end
    end

    describe "#create" do
        it "creating new movie" do
            count= Movie.count
            post :create, movie: {title: 'new_movie', director: 'new_director', rating:'R', release_date: '2021-3-11'}
            expect(flash[:notice]).to eq "new_movie was successfully created."
            expect(Movie.count).to eq(count+1)
            expect(response).to redirect_to(movies_path)
        end 
    end

    describe "#destroy" do
        it "destroying the movie" do
            movie_0 = Movie.create(title: 'movie', director: 'director', rating:'G', release_date: '2021-01-01')
            count= Movie.count
            delete :destroy, id: movie_0.id
            expect(flash[:notice]).to eq "Movie 'movie' deleted."
            expect(Movie.count).to eq(count-1)
            expect(response).to redirect_to movies_path
        end
    end
    
    describe "searches movies with same director" do
        it "finds movies with same director" do
            movie_1 = Movie.create(title: 'movie_1', director: 'director1')
            movie_2 = Movie.create(title: 'movie_2', director: 'director1')
            movie_3 = Movie.create(title: 'movie_3', director: 'director2')
            movie_4 = Movie.create(title: 'movie_4')
            get :movies_SameDirectors, id: movie_1.id
            expect(assigns(:movies)).to eq [movie_1, movie_2]
        end
        it "finds only this movie" do
            movie_1 = Movie.create(title: 'movie_1', director: 'director1')
            movie_2 = Movie.create(title: 'movie_2', director: 'director1')
            movie_3 = Movie.create(title: 'movie_3', director: 'director2')
            movie_4 = Movie.create(title: 'movie_4')
            get :movies_SameDirectors, id: movie_3.id
            expect(assigns(:movie)).to eq movie_3
        end
        it "has no director information" do
            movie_1 = Movie.create(title: 'movie_1', director: 'director1')
            movie_2 = Movie.create(title: 'movie_2', director: 'director1')
            movie_3 = Movie.create(title: 'movie_3', director: 'director2')
            movie_4 = Movie.create(title: 'movie_4')
            get :movies_SameDirectors, id: movie_4.id
            expect(flash[:notice]).to eq "'movie_4' has no director info."
            expect(response).to redirect_to movies_path
        end
            
    end
        
end