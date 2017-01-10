module HeyykaTranslator
  class FiltersGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    class_option :empty, desc: "Create empty files"

    def create_filters
      path = "config/heyyka_translator/"

      if options[:empty]
        create_file (path + "blacklist.yml"), ""
        create_file (path + "whitelist.yml"), ""
      else
        template (path + "blacklist.yml")
        template (path + "whitelist.yml")
      end
    end
  end
end
