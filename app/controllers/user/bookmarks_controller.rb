class User::BookmarksController < ApplicationController
  before_filter :authenticate_login!

  def create
    idea = current_account.ideas.find(params[:user_bookmark][:idea_id])
    @user_bookmark = current_user.bookmarks.new(idea: idea)
    if @user_bookmark.save
      flash[:success] = _('Bookmark successfuly added.')
    else
      flash[:error] = _('Failed to add bookmark.')
    end

    if @user_bookmark.idea
      redirect_to idea_path(@user_bookmark.idea)
    else
      redirect_to ideas_path(angle: 'followed')
    end
  end

  def destroy
    @user_bookmark = current_user.bookmarks.find(params[:id])
    @user_bookmark.destroy
    flash[:notice] = _("Successfully removed bookmark.")
    redirect_to idea_path(@user_bookmark.idea)
  end
end
