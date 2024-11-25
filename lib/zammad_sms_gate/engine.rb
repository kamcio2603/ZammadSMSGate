module ZammadSmsGate
  class Engine < ::Rails::Engine
    config.autoload_paths << File.expand_path("..", __FILE__)
    
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")).each do |c|
        require_dependency(c)
      end
    end
    
    config.to_prepare &method(:activate).to_proc
  end
end

