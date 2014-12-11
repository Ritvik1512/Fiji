module fiji
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      config.cache_store = :fiji_store
    end
  end
end
