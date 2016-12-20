module HeyykaTranslator
  class BlacklistGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    class_option :empty, desc: "Create a empty file"

    def get_blacklist
      if options[:empty]
        create_file "config/blacklist.yml", ""
      else
        template "config/blacklist.yml"
      end
    end
  end
end
