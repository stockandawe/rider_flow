RiderFlow::Application.routes.draw do
  root :to => 'contents#home'

  scope "api" do
    match 'lines' => 'api#lines'
    match 'lines/:id' => 'api#line'
    match 'lines/:id/buses' => 'api#buses'
    match 'lines/:id/buses/:bus' => 'api#buses'
    match 'lines/:id/stops' => 'api#stops'
    match 'lines/:id/stops/:stop' => 'api#stops'
  end
  
  match 'cron' => 'cron#riders'  
end
