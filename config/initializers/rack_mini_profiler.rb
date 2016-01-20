if defined?(Rack::MiniProfiler)
  Rack::MiniProfiler.config.start_hidden = true
  Rack::MiniProfiler.config.position = 'right'
end
