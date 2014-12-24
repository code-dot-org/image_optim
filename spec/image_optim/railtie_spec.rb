require 'spec_helper'

describe 'ImageOptim::Railtie' do
  require 'rails/all'
  require 'image_optim/railtie'

  def init_rails_app
    Class.new(Rails::Application) do
      # Rails 4 requires application class to have name
      def self.name
        'Dummy'
      end

      config.active_support.deprecation = :stderr
      config.eager_load = false

      config.logger = Logger.new('/dev/null')

      config.assets.enabled = true
      config.assets.version = '1.0'
      config.assets.cache_store = :null_store
      config.assets.paths = %w[spec/images]

      yield config if block_given?
    end.initialize!
  end

  after do
    Rails.application = nil
  end

  describe :initialization do
    it 'initializes by default' do
      expect(ImageOptim).to receive(:new)
      init_rails_app
    end

    it 'initializes if config.assets.image_optim is nil' do
      expect(ImageOptim).to receive(:new)
      init_rails_app do |config|
        config.assets.image_optim = nil
      end
    end

    it 'does not initialize if config.assets.image_optim is false' do
      expect(ImageOptim).not_to receive(:new)
      init_rails_app do |config|
        config.assets.image_optim = false
      end
    end

    it 'does not initialize if config.assets.compress is false' do
      expect(ImageOptim).not_to receive(:new)
      init_rails_app do |config|
        config.assets.compress = false
      end
    end
  end
end if ENV['RAILS_VERSION']
