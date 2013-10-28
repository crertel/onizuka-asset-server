class FilesController < ApplicationController

  def get
    FileRetrieval.new(self, params).apply
  end


  def file_found(file, options = {})
    send_file(file, options)
  end


  def file_not_found(message)
    respond_to do |format|
      format.html { render text: message }
      format.json { render json: message }
    end
  end

end
