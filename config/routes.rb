Rails.application.routes.draw do

  resources :uploads, only: [:index, :new, :create, :destroy]

  devise_for :users

  get 'users/:id' => 'users#show', as: :user
  get 'users/:id/images' => 'users#image_index'

  root 'images#index'

  get 'token/generate'
  get 'file/download'

  get 'images' => 'images#index'
  get 'images/:id' => 'images#singleimage'
  get 'images/:id/inspect' => 'images#inspect'
  get 'images/:id/exif' => 'images#exif'
  delete 'images/:id/delete' => 'images#delete'

  iiif_for 'riiif/image', at: '/iiif'


end
