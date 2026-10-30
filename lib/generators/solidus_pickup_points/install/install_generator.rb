# frozen_string_literal: true

module SolidusPickupPoints
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: false

      def self.exit_on_failure?
        true
      end

      def add_migrations
        run "bin/rails railties:install:migrations FROM=solidus_pickup_points"
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] ||
          ["", "y", "Y"].include?(ask("Would you like to run the migrations now? [Y/n]"))
        if run_migrations
          run "bin/rails db:migrate"
        else
          puts "Skipping bin/rails db:migrate, don't forget to run it!"
        end
      end
    end
  end
end
