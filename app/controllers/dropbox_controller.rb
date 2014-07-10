require "dropbox_sdk"

class DropboxController < ApplicationController

  before_filter :is_authorized_filter, :only => [:index, :download, :upload, :share]

  def authorize
    if not params[:oauth_token] then
      dbsession = DropboxSession.new(APP_KEY, APP_SECRET)
      session[:dropbox_session] = dbsession.serialize
      redirect_to dbsession.get_authorize_url url_for(:action => 'authorize')
    else
      dbsession = DropboxSession.deserialize(session[:dropbox_session])
      dbsession.get_access_token
      session[:dropbox_session] = dbsession.serialize
      redirect_to :action => 'index'
    end
  end

  def index
    @path = params['path'] ? params['path'] : '/'
    file_metadata = @client.metadata(@path)
    @contents = file_metadata['contents']
    #Rails.logger.debug(@client.share_link(@path + 'Software install'))
  end

  def download
    out, metadata = @client.get_file_and_metadata(params['path'])
    send_data out, :type => metadata['mime_type'], :filename => Pathname.new(params['path']).basename.to_s, :x_sendfile=>true
  end

  def upload
    @client.put_file('/' + params['path'] + '/' + params['file'].original_filename, open(params['file'].tempfile))
    redirect_to :action => 'index', :path => params['path']
  end

  def share
    @share_link = @client.shares(params['path'])
    @share_link = @share_link['url']

    respond_to do |format|
      format.json { render :json => { :share_link => @share_link} }
    end
  end
  #dropbox_share_path('path' => content['path'])
  private

  def is_authorized_filter
    return redirect_to(:action => 'authorize') unless session[:dropbox_session]
    dbsession = DropboxSession.deserialize(session[:dropbox_session])
    @client = DropboxClient.new(dbsession, ACCESS_TYPE)
  end

end
