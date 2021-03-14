Rottenpotatoes::Application.routes.draw do
 resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  get 'movies_SameDirectors/:id', to: 'movies#movies_SameDirectors', as: 'movies_SameDirectors_movie'
end