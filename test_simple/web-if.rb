# web-if.rb - Sinatra interfact to Java snpEff


# need to require sucker_punch to make it work before require of Sinatra
require 'sucker_punch'
require 'sinatra'
require 'json'

# we have our own error handling
set :show_exceptions, false
# modify this file to set the path where to move uploaded files
require_relative 'snp_data_path'

# library methods/objects to create/query job status
require_relative 'lib/application'

# HTTP Basic Authentication
use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == 'admin' and password == 'admin'
end

# extracted hash errors
def errors_hash *errors
  {'Errors': errors}
end

# error handling. Errors are returned in JSON 'Errors': [err 1, err 2, ... ]
def errors_json *errors
  errors_hash(errors).to_json
end

# return a link along with errors in JSON
def errors_link_json link, *errors
  eh = errors_hash errors
  eh["Link"] = link
  eh.to_json
end


# sanity check route / reports Sinatra is working
get '/' do
  {"Sinatra status": "Working", "Version": Sinatra::VERSION}.to_json
end

get '/version' do
  {"Java version": `java -version 2>&1`}.to_json
end

# path to snpEff.jar
snp_eff_path =  '/root/snpEff/snpEff'
get '/help' do
  {"snpEff help": `java -jar  #{snp_eff_path}/snpEff.jar 2>&1`}.to_json
end

# report a list of routes this app supports in JSON format
# NOTE: Add route description to snp_eff_routs array as you add them
snp_eff_routes = [
{"/": "Status of Sinatra server"},
{"/version": "Version of Java runtime"},
{"/help": "Help message from snpEff.jar"},
  {"/upload": "POST upload .vcf file to be processed. Returns Id and Link of status of Job"},
  {"/status/Id -...": "Returns status of Job with Id"},
  {"/download/Id -...": "Returns output .vcf once Job with Id is done"},
{"/routes": "This JSON list of routes"}
]

get '/routes' do
  {"Routes": snp_eff_routes}.to_json
end


post '/upload' do
  halt(400, errors_json('Missing filedata field')) if params['filedata'].nil?
  tempfile = params['filedata'][:tempfile]
  #filename = params['filedata'][:filename]
#puts ">>> tmpfile: #{tempfile.path}"
#puts ">>> filename: #{filename}"
#p params
  status = SnpJob::Status.create tempfile.path
  begin
    SnpJobWorker.new.async.perform(status.path)
  rescue => err
    puts '~~~~~~~~~~~~~~~~~'
    puts err.class.name
    puts err.message
  end
  {"Status": status.to_s,
     "Id": status.guid, 
    "Link": url("/status/#{status.guid}")}.to_json
end



# get status (pending, working, failed, finished or error
get %r{/status/([0-9a-f\-]+)} do |c|
  status = SnpJob::Status.new c
  halt(404, errors_json("Id #{c} not found")) unless status.exist?
  response = {"Status": status.to_s}
  response["Link"] = url("/download/#{status.guid}") if status.to_s == 'finished'
  response.to_json
end

# return the processed file
get %r{/download/([0-9a-f\-]+)} do |c|
  status = SnpJob::Status.new c
  halt(404, errors_json("Id #{c} not found")) unless status.exist?
  halt(404, errors_json('Job failed.', 'Unable to download this request.')) if status.to_s == 'failed'
  halt(404, 
    errors_link_json(url("/status/#{status.guid}"), 
    'Job in progress', 'INFO: Use Link to get of current job status')) unless status.to_s == 'finished'
  File.read("#{status.finished}/output.vcf")
end

# catch all route
get '/*' do
  halt(404, errors_json("Not Found #{params[:splat]}"))
end
