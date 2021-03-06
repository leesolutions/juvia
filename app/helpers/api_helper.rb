module ApiHelper
  def juvia_handle_response(options)
    "Juvia.handleResponse(#{options.to_json})".html_safe
  end

  def jsonp_response(options)
  	raise "'@jsonp' must be set!" if !@jsonp
  	"#{@jsonp}(#{options.to_json})".html_safe
  end

  def define(value)
    block_given?? yield(value) : value
  end

  def app_host
    Rails.application.config.base_url
  end
end
