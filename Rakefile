begin
  require 'spec'
  require 'spec/rake/spectask'
  desc 'Run the cucumber-screenshot specs'
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = ['--options', 'spec/spec.opts']
  end
rescue LoadError
  puts 'Rspec not available, install it with: gem install rspec'
end


require 'rubygems'
require 'rake/gempackagetask'
require 'rake/rdoctask'

task :default => ['spec']

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|
  # Change these as appropriate
  s.name              = 'cucumber-screenshot'
  s.version           = '0.3.2'
  s.summary           = 'Extension for Cucumber to capture HTML snapshots/PNG screenshots of your app'

  s.description       = 'Extension for Cucumber (http://cukes.info/) that makes it easy to take HTML snapshots and also to use Webkit to capture PNG screenshots of your web application during tests'
  s.author            = 'Joel Chippindale'
  s.email             = 'joel.chippindale@gmail.com'
  s.homepage          = 'http://github.com/mocoso/cucumber-screenshot'

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README.rdoc)
  s.rdoc_options      = %w(--main README.rdoc)

  # Add any extra files to include in the gem
  s.files             = %w(cucumber-screenshot.gemspec cucumber-screenshot.tmproj MIT-LICENSE Rakefile README.rdoc) + Dir.glob("{spec,lib/**/*}")
  s.require_paths     = ["lib"]

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  # s.add_dependency("some_other_gem", "~> 0.1.0")

  s.add_dependency('cucumber', '>= 0.6.2')
  s.add_dependency('webrat', '>= 0.7.0')

  # If your tests use any gems, include them here
  s.add_development_dependency('rspec')

  s.post_install_message = 'To take actual screenshots rather than just snapshots of the HTML returned you will need Mac OS X 10.5 or later with RubyCocoa.

You will also need to install the snapurl gem

    gem install snapurl --version=0.3.0

For details about how to set up your features to make use of cucumber-screenshot see http://github.com/mocoso/cucumber-screenshot'

  s.requirements = ['Mac OS X 10.5 or later', 'RubyCocoa']
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
#
# To publish your gem online, install the 'gemcutter' gem; Read more
# about that here: http://gemcutter.org/pages/gem_docs
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

task :package => :gemspec

# Generate documentation
Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end
