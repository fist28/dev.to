class GitlabTag < LiquidTagBase
  def initialize(tag_name, link, tokens)
    super
    @tag_name = tag_name
    @link = link
    @tokens = tokens
    @rendered = pre_render
  end

  def issue_or_readme
    if @link.include?("issues") || @link.include?("merge_requests")
      "issue"
    else
      "readme"
    end
  end

  def pre_render
    if issue_or_readme == "issue"
      GitlabTag::GitlabIssueTag.new(@link).render
    elsif issue_or_readme == "readme"
      GitlabTag::GitlabReadmeTag.new(@link).render
    end
  rescue StandardError => e
    raise StandardError, e.message
  end

  def render(*)
    @rendered
  end
end

Liquid::Template.register_tag("gitlab", GitlabTag)