begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name         = "cucumber-screenshot"
    gemspec.summary      = "Cucumber formatter that outputs PNG screenshots of your app"
    gemspec.description  = "Cucumber (http://cukes.info/) formatter that uses Webkit to capture PNG screenshots of your web application during tests"
    gemspec.platform     = "universal-darwin"
    gemspec.requirements << "Mac OS X 10.5 or later"
    gemspec.requirements << "RubyCocoa"
    gemspec.add_dependency('cucumber', '= 0.4.2')
    gemspec.add_dependency('webrat', '= 0.5.3')
    gemspec.add_dependency('snapurl', '>= 0.0.3')
    gemspec.email        = 'joel.chippindale@gmail.com'
    gemspec.authors      = ['Joel Chippindale']
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

begin
  require 'spec/rake/spectask'
  desc "Run the cucumber-screenshot specs"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = ['--options', 'spec/spec.opts']
  end
rescue LoadError
  puts 'Rspec not available, install it with: sudo gem install rspec'
end
