you have to set envs or api url in `frontend-app/App.js:13`
# build
you need ruby 3.2.2
to install rails related stuff run `bundle install`
to install frontend related stuff go to `frontend-app` and run `npm install`
# run
to run rails server run `rails s`
to run frontend you have to go `frontend-app` and run `npm start`
rails and react use the same port by default so you have to set diferent port for one of them
# data seeds
to seed your database run `bundle exec rake json_import:import`
