#!/usr/bin/env ruby

require 'sinatra'
require 'sequel'
require 'json'

DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost/geotag')

DB.create_table? :tags do
  primary_key :id
  Float :longitude
  Float :latitude
  DateTime :created_at
end

tags = DB[:tags]

get '/' do
  @page = "home"
  erb :index
end

get '/tags' do
  @page = "list"
  @tags = tags.all
  erb :tags
end

post '/tags' do
  @tag = {
    longitude: params[:longitude],
    latitude: params[:latitude],
    created_at: DateTime.now
  }
  
  @tag[:id] = tags.insert(@tag)
  return @tag.to_json
end