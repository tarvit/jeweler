require 'date'

require 'jeweler/bumping'
require 'jeweler/versioning'
require 'jeweler/gemspec'
require 'jeweler/errors'
require 'jeweler/generator'
require 'jeweler/release'

require 'jeweler/tasks'

# A Jeweler helps you craft the perfect Rubygem. Give him a gemspec, and he takes care of the rest.
class Jeweler
  include Jeweler::Bumping
  include Jeweler::Versioning
  include Jeweler::Gemspec
  include Jeweler::Release

  attr_reader :gemspec
  attr_accessor :base_dir

  def initialize(gemspec, base_dir = '.')
    raise(GemspecError, "Can't create a Jeweler with a nil gemspec") if gemspec.nil?
    @gemspec = gemspec
    @base_dir = base_dir
    
    if @gemspec.files.nil? || @gemspec.files.empty?
      @gemspec.files = FileList["[A-Z]*.*", "{bin,generators,lib,test,spec}/**/*"]
    end

    if File.exists?(File.join(base_dir, '.git'))
      @repo = Git.open(base_dir)
    end
  end

  protected
    def any_pending_changes?
      !(@repo.status.added.empty? && @repo.status.deleted.empty? && @repo.status.changed.empty?)
    end
end

