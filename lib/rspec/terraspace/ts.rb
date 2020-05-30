require "json"

module RSpec::Terraspace
  class Ts
    extend Memoist

    CLI = ::Terraspace::CLI

    def build_test_harness(options={})
      puts "Building test harness..."
      project = Project.new(options)
      @ts_root = project.create
      ENV['TS_ROOT'] = @ts_root # switch root to the generated test harness
    end

    def up(args)
      run("up #{args} -y")
      mod = args.split(' ').first
      @mod = ::Terraspace::Mod.new(mod)
      save_output
    end

    def down(args)
      run("down #{args} -y")
    end

    def run(command)
      puts "=> terraspace #{command}".color(:green)
      args = command.split(' ')
      CLI.start(args)
    end

    # Note: a terraspace.down will remove the output.json since it does a clean
    def save_output
      run("output #{@mod.name} --format json --out output.json")
    end

    def output(mod, name)
      data = JSON.load(IO.read("output.json"))
      data.dig(name, "value")
    end
  end
end
