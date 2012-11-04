class User::BookmarksController < ApplicationController
  def index
    @user_bookmarks = User::Bookmark.all
  end

  def show
    @user_bookmark = User::Bookmark.find(params[:id])
  end

  def new
    @user_bookmark = User::Bookmark.new
  end

  def create
    @user_bookmark = User::Bookmark.new(params[:user_bookmark])
    if @user_bookmark.save
      redirect_to @user_bookmark, :notice => "Successfully created user/bookmark."
    else
      render :action => 'new'
    end
  end

  def edit
    @user_bookmark = User::Bookmark.find(params[:id])
  end

  def update
    @user_bookmark = User::Bookmark.find(params[:id])
    if @user_bookmark.update_attributes(params[:user_bookmark])
      redirect_to @user_bookmark, :notice  => "Successfully updated user/bookmark."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user_bookmark = User::Bookmark.find(params[:id])
    @user_bookmark.destroy
    redirect_to user_bookmarks_url, :notice => "Successfully destroyed user/bookmark."
  end
end
