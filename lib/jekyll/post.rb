puts "INCLUDE POST EXT."

module Jekyll
  class Post

    alias :liquid_data :to_liquid

    def to_liquid
      liquid_data.deep_merge({
        "file_name" => file_name
      })
    end

  private

    def file_name
      # TODO: use File
      [@base, @name].join('/')
    end

  end
end
