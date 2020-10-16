module MarkdownHelper
  def render_markdown(content)
    extensions = {
      autolink: true,
      space_after_headers: true,
      fenced_code_blocks: true,
      tables: true,
      strikethrough: true,
    }
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions)
    markdown.render(h(content)).html_safe
  end
end
