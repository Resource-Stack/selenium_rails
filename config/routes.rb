
Rails.application.routes.draw do
  get 'users/index'
  get 'sortable/reorder'
  devise_for :users
  devise_scope :user do
    root to: "devise/sessions#new", via: 'get'
    match '/logout', to: "devise/sessions#destroy", via: 'get'
    match '/invitation/resend_invite' => 'invitations#resend_invite', via: [:post]
  end
  resources :test_suites do
    put :sort, on: :collection
  end

  resources :results_dictionaries

  resources :result_cases

  resources :result_suites

  resources :environments

  resources :test_cases

  resources :custom_commands

  
  match '/home', to: "welcome#home", via: ["get", "post"]
  
  match "environments(/:id)/test_suites", to: "environments#test_suites", via: "get"

  match "/list_all_reports", to: "environments#list_all_reports", via: "get"
  match "/list_all_result_suites", to: "result_suites#list_all_result_suites", via: "get"

  match "/reports", to: "environments#reports", via: ["get", "post"]

  match "/filter_reports", to: "environments#filter_reports", via: ["get", "post"]


  match "run_suites", to: "environments#run_suites", via: "get"

  match "custom_commands", to: "custom_commands#custom_commands", via: "get"
  
  match "run_suites", to: "environments#run_suites", via: "post"
  
  match 'test_suites(/:id)/test_cases', to: "test_suites#test_cases", via: "get"

  match 'test_suites(/:id)/test_cases', to: "test_suites#test_cases", via: "get"

  match 'test_suites(/:id)/tests_ran', to: "test_suites#tests_ran", via: "get"

  match 'test_suites(/:id)/unschedule', to: "test_suites#unschedule", via: [:get , :post]
  
  match '/modal_show', to: "test_cases#modal_show", via: "get"
  
  match "import_suite", to: "test_suites#import_suite", via: "get"

  match "images", to: "environments#images", via: "get"

  match 'export_results', to: "test_cases#export_results", via: "get"

  match 'download_results', to: "environments#download_results", via: "get"

  match 'export', to: "test_cases#export", via: "get"
  
  post "import" => "test_suites#import"

  post 'update' => "users#update"

 
  #Browser Extension Apis
  match '/api/login', :to => 'browser_extension#login_user',  via: [:post]
  match '/api/logout', :to => 'browser_extension#logout_user',  via: [:get]
  match '/api/get_environments', :to => 'browser_extension#get_environments',  via: [:get]
  match '/api/get_custom_commands', :to => 'browser_extension#get_custom_commands',  via: [:get]
  match '/api/create_test_suite', :to => 'browser_extension#create_test_suite',  via: [:post]
  match '/api/get_test_suites', :to => 'browser_extension#get_test_suites',  via: [:get]
  match '/api/create_test_case', :to => 'browser_extension#create_test_case',  via: [:post]
  match '/api/update_test_case', :to => 'browser_extension#update_test_case',  via: [:post]
  match '/api/get_test_cases', :to => 'browser_extension#get_test_cases',  via: [:get]
  match '/api/get_case_detail', :to => 'browser_extension#get_case_detail',  via: [:get]

  match '/suite_schedule/create_suite_schedule', :to => 'suite_schedule#create_suite_schedule',  via: [:post]
  match '/suite_schedule/get_suite_schedules', :to => 'suite_schedule#get_suite_schedules',  via: [:post]
  match '/suite_schedule/update_suite_schedule', :to => 'suite_schedule#update_suite_schedule',  via: [:post]
  match '/suite_schedule/delete_suite_schedule', :to => 'suite_schedule#delete_suite_schedule',  via: [:get]


  get '/terms' => 'terms_and_conditions#terms_and_conditions'
  post '/acknowledge_terms' => 'terms_and_conditions#acknowledge_terms'
  get '/privacy' => 'privacy_policies#privacy_policy'
  post '/acknowledge_privacy' => 'privacy_policies#acknowledge_privacy'

  post '/update_suite_flow' => 'test_suites#update_suite_flow'
  get '/edit_test_case' => 'test_cases#edit_test_case'

  post "/invite_user" => "users#invite_user"
  delete "/remove_invitation" => "users#remove_invitation"
  get "/resend_invitation" => "users#resend_invitation"

  get "projects/index"

  match "/projects", to: "projects#index", via: ["get"]
  delete "/delete_project" => "projects#delete_project"
  post "/create_project" => "projects#create_project"
end

