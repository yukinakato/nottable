module MarkdownHelper
  def render_markdown(content)
    extensions = {
      autolink: true,
      space_after_headers: true,
      fenced_code_blocks: true,
      tables: true,
      strikethrough: true,
    }
    renderer = Redcarpet::Render::HTML.new(escape_html: true)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render((content)).html_safe
  end
end
