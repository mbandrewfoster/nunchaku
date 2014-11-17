module Nunchaku::ApplicationHelper
  include Nunchaku::LocaleHelper
  include Nunchaku::ThemeHelper
  include Nunchaku::IconsHelper

  def engine_name
    controller.class.name.split('::').first.downcase
  end

  def engine_path(*args)
    l = args.flatten.last
    klass = l.is_a?(Class) ? l : l.class

    send(path_prefix(klass)).polymorphic_path(args)
  rescue
    polymorphic_path(args)
  end

  protected

  def path_prefix(klass)
    klass.name.deconstantize.underscore
  end
end
