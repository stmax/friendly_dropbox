module DropboxHelper

  def show_icon(is_dir)
    if is_dir
      result = 'folder.png'
    else
      result = 'file.png'
    end
    result
  end

  def get_name_from_path(path)
    path.lines('/').to_a.last
  end

end
