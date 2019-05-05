module Eskort
  module Bundler
    class Command

      def bundle_update(gem_name)
        command = ::Cocaine::CommandLine.new('bundle update', ':gem_name')
        command.run(gem_name: gem_name)
      end

      def git_config_global(email:, name:)
        command_email = ::Cocaine::CommandLine.new('git config', '--global user.email :email')
        command_email.run(email: email)
        command_name = ::Cocaine::CommandLine.new('git config', '--global user.name :name')
        command_name.run(name: name)
      end

      def git_checkout(branch_name)
        command = ::Cocaine::CommandLine.new('git checkout', '-b :branch_name origin/master')
        command.run(branch_name: branch_name)
      end

      def git_commit(gem_name, gem_version)
        command = ::Cocaine::CommandLine.new('git commit', ":filename -m 'Auto update :gem_name to version :gem_version'")
        command.run(filename: 'Gemfile.lock', gem_name: gem_name, gem_version: gem_version)
      end

      def git_push(branch_name)
        command = ::Cocaine::CommandLine.new('git push origin', ':branch_name')
        command.run(branch_name: branch_name)
      end

    end
  end
end
