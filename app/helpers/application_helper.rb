module ApplicationHelper
    def full_title(page_title)
      base_title = "Base Title of the Sample App on Ruby on Rails 4"
      if page_title.empty?
        base_title
      else
        "#{ base_title } | #{ page_ title }"
      end
    end
end
