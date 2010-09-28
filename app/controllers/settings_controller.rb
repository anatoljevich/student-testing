class SettingsController < ApplicationController
  before_filter :login_required
  
  def index
    @author = current_author
    if params[:author]
      if params[:author][:fio]
        flash[:notice] = 'ФИО изменено' if @author.change_fio params[:author]
      elsif params[:author][:password]
        flash[:notice] = 'Пароль изменен' if @author.change_password params[:author]
      end
    end
  end
end
