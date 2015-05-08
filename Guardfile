group :red_green_refactor, halt_on_fail: true do

  guard :jasmine, server: :webrick, server_mount: "/specs", server_env: :development do
    watch(%r{spec/javascripts/spec\.(js\.coffee|js|coffee)$}) { "spec/javascripts" }
    watch(%r{spec/javascripts/.+_spec\.(js\.coffee|js|coffee)$})
    watch(%r{spec/javascripts/fixtures/.+$})
    watch(%r{app/assets/javascripts/(.+?)\.(js\.coffee|js|coffee)(?:\.\w+)*$}) { |m| "spec/javascripts/#{ m[1] }_spec.#{ m[2] }" }
  end

  guard :rspec, cmd: "bundle exec rspec", all_on_start: true do
    require "guard/rspec/dsl"
    dsl = Guard::RSpec::Dsl.new(self)

    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)

    # Rails files
    rails = dsl.rails(view_extensions: %w(erb haml slim))
    dsl.watch_spec_files_for(rails.app_files)
    dsl.watch_spec_files_for(rails.views)

    watch(rails.controllers) do |m|
      [
        rspec.spec.("routing/#{m[1]}_routing"),
        rspec.spec.("controllers/#{m[1]}_controller"),
        rspec.spec.("acceptance/#{m[1]}")
      ]
    end

    # Rails config changes
    watch(rails.spec_helper)     { rspec.spec_dir }
    watch(rails.routes)          { "#{rspec.spec_dir}/routing" }
    watch(rails.app_controller)  { "#{rspec.spec_dir}/controllers" }

    # Capybara features specs
    watch(rails.view_dirs)     { |m| rspec.spec.("features/#{m[1]}") }
    watch("app/controllers/solicitor_arrival_times_controller.rb") { "spec/features/solicitor/defence_request_management_spec.rb" }

  end

  guard :rubocop do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end
