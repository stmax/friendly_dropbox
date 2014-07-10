require 'dropbox_sdk'

DropboxClient.class_eval do
  def share_link(path)
    response = @session.do_get build_url("/shares/#{@root}#{format_path(path)}")
    Dropbox::parse_response(response)
  end
end
