# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.scss, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
      main.css
      main_ie6.css
      main_ie7.css
      main_ie8.css
      ie6_overrides.css
      ie7_overrides.css
      font-awesome-ie7.min.css
      dashboard_poller.js
    )
