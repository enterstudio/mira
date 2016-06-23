class DatasourcesController < ApplicationController

  include ApplicationHelper
  include DataAccessHelper

  before_action :authenticate_user!, only: [:destroy]
  before_action :correct_user, only: [:destroy]

  before_action :key_authorize_read, only: [:show, :index]
  # before_action :key_authorize_write, only: [:destroy, :update]

  def show
    @ds = Datasource.find(params[:id])
    send_file @ds.datafile.path, :type => @ds.datafile_content_type #, :disposition => 'inline'
  end

  def index
    @proj = Project.find(params[:project_id])
    @dss = @proj.datasources.page params[:page]
  end

  def destroy
    @ds = Datasource.where(id: params[:id]).first
    # delete_associated_artifacts
    remove_datasource_rows_from_db_table
    Datasource.find(params[:id]).destroy
    redirect_to project_path(params[:project_id])
  end

  private
    def correct_user
      binding.pry
      @ds = current_user.projects.find_by(id: params[:project_id]).datasources.find_by(id: params[:id])
      redirect_to root_url if @ds.nil?
    end



    def remove_datasource_rows_from_db_table
      binding.pry
      # ar_table = Mira::Application.const_get(self.db_table_name.capitalize.to_sym)
      # if ActiveRecord::Base.connection.table_exists? ar_table.to_s.downcase
      #   ar_table.delete_all
      # end
    end
end
