module Notice::GenerateUrl
  # メソッド
  def generate_path(method_name, *args)
    send("#{method_name}_path", *args)
  end


  # メソッド (private)
  private

  def routes
    Rails.application.routes.url_helpers
  end

  ## コメント
  def create_comment_path(comment)
    routes.item_path(comment.item)
  end
end
