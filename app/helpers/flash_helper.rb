module FlashHelper
  # devise の作る flash を bootstrap の適切な色に対応させるヘルパー
  def bootstrap_alert(key)
    case key
    when 'alert'
      'warning'
    when 'notice'
      'success'
    when 'error'
      'danger'
    else
      key
    end
  end
end
