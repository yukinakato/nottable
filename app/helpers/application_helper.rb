module ApplicationHelper
  def full_title(page_title: "")
    if page_title.blank?
      Constants::SITE_NAME
    else
      "#{page_title} | #{Constants::SITE_NAME}"
    end
  end
end
