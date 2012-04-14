module Jekyll
  class Post

    alias :liquid_data :to_liquid

    def to_liquid
      file_name = File.join(@base, @name)

      liquid_data.deep_merge({
        "file_name" => file_name
      })
    end

  end
end
