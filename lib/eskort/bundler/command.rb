module Eskort
  module Bundler
    class Command
      def bundle_update(gem_name)
        Kernel.system("bundle update #{gem_name}")
      end

      def git_config_global(email:, name:)
        Kernel.system("git config --global user.email #{email}")
        Kernel.system("git config --global user.name #{name}")
      end

      def git_checkout(branch_name)
        Kernel.system("git checkout -b #{branch_name} origin/master")
      end

      def git_commit(gem_name, gem_version)
        Kernel.system("git commit Gemfile.lock -m \'Auto update #{gem_name} to version #{gem_version}\'")
      end

      def git_push(branch_name)
        Kernel.system("git push origin #{branch_name}")
      end
    end
  end
end
