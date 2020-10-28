module Notice::GenerateMessage
  # ===== ユーザが自由に入力できる値は必ずサニタイズすること =====

  # メソッド
  def generate_message(method_name, *args)
    send("#{method_name}_message", *args)
  end


  # メソッド (private)
  private

  def notice_sanitize(comment)
    @full_sanitizer ||= Rails::Html::FullSanitizer.new
    @full_sanitizer.sanitize(comment)
  end

  ## コメント
  def create_comment_message(comment)
    body = if comment.body.present?
             "『#{notice_sanitize(comment.body).truncate(Notice::MESSAGE_LIMIT)}』"
           end
    user_name = notice_sanitize(comment.user_name)
    "<span class='font-weight-bold'>#{user_name}</span>さん：" + body
  end
end
