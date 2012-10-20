RiderFlow::Application.routes.draw do
  root :to => 'contents#home'
  
  scope "api" do
    match 'lines/:id' => 'api#line'
  end
end
