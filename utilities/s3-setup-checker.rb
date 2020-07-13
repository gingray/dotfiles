#!/usr/bin/env ruby

# gem install aws-sdk-s3
# gem install faraday
require 'aws-sdk-s3'
require 'faraday'

# https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/debugging.html
#
AWS_ACCESS_KEY = ''
AWS_SECRET_ACCESS_KEY = ''
AWS_REGION = '' #eu-central-1
AWS_BUCKET_NAME = ''
CORS_ORIGIN = '' #https://development.com

client = Aws::S3::Client.new(
    region: AWS_REGION,
    access_key_id: AWS_ACCESS_KEY,
    secret_access_key: AWS_SECRET_ACCESS_KEY,
    # http_wire_trace: true
    )
resource = Aws::S3::Resource.new(client: client)
s3 = resource.bucket(AWS_BUCKET_NAME)

begin
  puts "[CHECK] Objects list"
  s3.objects.to_a
rescue => e
  puts "Object list error #{e.message}"
  exit
end
puts "[PASS ] Objects list"

begin
  puts "[CHECK] Put object"
  obj =  s3.object('test-aws')
  obj.put(body: StringIO.new("test-aws"))
rescue => e
  puts "Put Object error #{e.message}"
  exit
end
puts "[PASS ] Put object"

begin
  puts "[CHECK] Get object"
  s3.object('test-aws').get.body.read
rescue => e
  puts "Get Object error #{e.message}"
  exit
end
puts "[PASS ] Get object"

begin
  puts "[CHECK] Delete object"
  s3.object('test-aws').delete
rescue => e
  puts "Delete Object error #{e.message}"
  exit
end
puts "[PASS ] Delete object"

puts "[CHECK] CORS"
url = s3.object('test-presigned').presigned_url :put
resp = Faraday.options(url, {}, {'Origin' => CORS_ORIGIN, 'Access-Control-Request-Method'=> 'PUT', 'Access-Control-Request-Headers' => 'content-md5,content-type'})

if resp.status != 200
  puts "[CORS] ERROR check"
  puts "[STATUS] #{resp.status}"
  puts "[BODY] #{resp.body}"
  puts "[HEADERS] #{resp.headers}"
  exit
end
puts "[PASS ] CORS"

