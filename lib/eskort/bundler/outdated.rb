module Eskort
  module Bundler

    class Outdated

      def list # rubocop:disable Metrics/AbcSize
        outdated_gems_list = []

        current_specs = ::Bundler.ui.silence { ::Bundler.definition.resolve }

        current_dependencies = {}
        ::Bundler.ui.silence do
          ::Bundler.load.dependencies.each do |dep|
            current_dependencies[dep.name] = dep
          end
        end

        gemfile_specs, dependency_specs = current_specs.partition do |spec|
          current_dependencies.key?(spec.name)
        end

        definition = ::Bundler::Definition.build('Gemfile', 'Gemfile.lock', true).tap(&:resolve_remotely!)

        target_specs = gemfile_specs + dependency_specs
        target_specs.sort_by(&:name).each do |current_spec|
          dependency = current_dependencies[current_spec.name]

          # trueで実行するとGemfileで許可されているUpdate可能なものだけをリストする
          active_spec = retrieve_active_spec(true, definition, current_spec)

          next if active_spec.nil?
          next if !outdated?(active_spec, current_spec) && (current_spec.git_version == active_spec.git_version)

          outdated_gems_list << Gem.new(active_spec, current_spec, dependency)
        end
        outdated_gems_list
      end

      private

      def outdated?(active_spec, current_spec)
        ::Gem::Version.new(active_spec.version) > ::Gem::Version.new(current_spec.version)
      end

      def retrieve_active_spec(strict, definition, current_spec)
        if strict
          active_spec = definition.find_resolved_spec(current_spec)
        else
          active_specs = definition.find_indexed_specs(current_spec)
          active_specs.delete_if { |b| b.respond_to?(:version) && b.version.prerelease? } if !current_spec.version.prerelease? && active_specs.size > 1
          active_spec = active_specs.last
        end
        active_spec
      end

      class Gem

        attr_reader :active_spec, :current_spec, :dependency

        def initialize(active_spec, current_spec, dependency)
          @active_spec = active_spec
          @current_spec = current_spec
          @dependency = dependency
        end
      end
    end
  end
end
