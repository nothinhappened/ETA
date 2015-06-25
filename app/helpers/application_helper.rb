module ApplicationHelper
  # obtain the flash class string,
  # converting from rails keys to bootstrap keys
  # source: https://coderwall.com/p/jzofog
  def flash_class(level)
    case level
      when 'notice'   then 'alert alert-info'
      when 'success'  then 'alert alert-success'
      when 'error'    then 'alert alert-warning'
      when 'alert'    then 'alert alert-error'
      else 'alert alert-info'
    end
  end
end