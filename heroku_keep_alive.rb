require 'thread'
require 'optparse'
require 'net/http'
require 'yaml'

run_opts = {
  config: File.expand_path('../config.yml', __FILE__),
  sleep_time_interval: 360
}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on('-v', '--verbose', 'Run with verbose output') do |v|
    run_opts[:verbose] = v
  end

  opts.on('-c', '--config', "Config file, defaults to #{run_opts[:config]}") do |v|
    run_opts[:config] = v
  end
end.tap(&:parse!)

config = YAML.load(File.read(run_opts[:config]))
config.each_value {|o| o['url'] = URI(o['url']) }

def log(msg)
  print "[#{Time.now.utc.to_s.sub(' UTC', '')}] #{msg}\n"
end

threads = []
config.each do |site, options|
  puts "Monitoring #{site} at #{options['url']}"

  threads << Thread.new do
    loop do
      begin
        resp = Net::HTTP.get_response(options['url'])
        log "Got a #{resp.code} from #{site}"
      rescue Exception => e
        log "Looks like #{site} may be down? Error was #{e.message}"
      end
      sleep_time = (rand * run_opts[:sleep_time_interval]).round
      log "Sleeping for #{sleep_time} seconds before trying #{site} again..."
      sleep sleep_time
    end
  end
end

threads.each(&:join)
