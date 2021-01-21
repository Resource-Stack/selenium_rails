# Be sure to restart your server when you modify this file.
Rails.application.config.assets.precompile += %w( drawflow.js )
Rails.application.config.assets.precompile += %w( font-awesome.js )
Rails.application.config.assets.precompile += %w( drawflow.css )

Rails.application.config.assets.precompile += %w( editor/ace.js )
Rails.application.config.assets.precompile += %w( editor/ext-tern.js ) 
Rails.application.config.assets.precompile += %w( editor/snippets/javascript.js ) 
Rails.application.config.assets.precompile += %w( editor/mode-javascript.js ) 
Rails.application.config.assets.precompile += %w( editor/theme-chrome.js ) 
Rails.application.config.assets.precompile += %w( editor/worker-tern.js ) 
Rails.application.config.assets.precompile += %w( editor/worker-javascript.js ) 

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
