Rails.application.routes.draw do

  resources :projects

  get 'project_reports/index'

  get 'project_reports/edit'

  get 'user_reports/index'

  get 'user_reports/edit'

  resources :users, except:   [:destroy]  do
    member do
      get   'admin_edit'
      get   'admin_show'
      patch 'admin_update'
      patch 'archive'
      patch 'unarchive'
    end

    collection do
      get 'index_archived'
    end
  end

  resources :tasks, except: [:destroy] do
    member do
      patch 'archive'
      patch 'unarchive'
    end

    collection do
      get 'index_archived'      
    end
  end
  resources :organizations,   only: [:new, :create]
  resources :sessions,        only: [:new,:create,:destroy]
  resources :timesheets,      only: [:create,:destroy,:index,:edit]
  resources :user_tasks,      only: [:edit, :show, :update, :index]
  resources :unlocked_times,    only: [:new,:create, :index, :update,:destroy]

  #match "/time_entries/view_edit", to:"time_entries#view_edit", via: "post"  
  #match "/time_entries/update_table", to:"time_entries#update_table", via: ["get","post"]  
  #get "/time_entries/get_last_week", to:"time_entries#get_last_week"  
  #resources :time_entries
  resources :time_entries do    
    collection do            
      post  'update_timesheet'
      get   'get_last_week'      
      get   'get_target_week'

      get   'update_table'
      post  'update_table'      
      get   'get_time_entries'
    end
  end

  resources :user_reports, only:     [:index, :edit] do
    collection do
      post 'get_last_month'
      post 'get_next_month'
    end
  end
  resources :project_reports, only:     [:index, :edit] do
    collection do
      post 'get_last_month'
      post 'get_next_month'
    end
  end

  root "static_pages#home"
  match "/home",    to: "static_pages#home",    via: "get",   as: "home_page"
  match "/about",   to: "static_pages#about",   via: "get",   as: "about_page"
  match "/contact", to: "static_pages#contact", via: "get",   as: "contact_page"
  match "/help",    to: "static_pages#help",    via: "get",   as: "help_page"
  match "/company_website", to:"static_pages#company_website", via: "get", as: "company_website"
  match "/signup",  to: "organizations#new",    via: "get"
  match "/signin",  to: "sessions#new",         via: "get"
  match "/signout", to: "sessions#destroy",     via: "delete"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
