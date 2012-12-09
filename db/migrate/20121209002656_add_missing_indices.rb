class AddMissingIndices < ActiveRecord::Migration
  def self.up
    try_add_index :users,          [:account_id, :id]

    try_add_index :vettings,       [:user_id, :idea_id]
    try_add_index :vettings,       [:created_at]

    try_add_index :votes,          [:subject_type, :user_id, :subject_id]
    try_add_index :votes,          [:created_at]

    try_add_index :user_roles,     :user_id
    try_add_index :user_roles,     [:name, :user_id]

    try_add_index :notifications,  [:unread, :recipient_id, :subject_type, :subject_id], name: 'index_notifications_on_subject_and_recipient'

    try_add_index :user_bookmarks, [:user_id, :idea_id]

    try_add_index :comments,       [:idea_id, :author_id]
    try_add_index :comments,       [:updated_at, :created_at], 
        order:{ created_at: :desc },
        name:'index_comments_on_timestamps'

    try_add_index :ideas,          [:author_id, :active_at],
        order:{ active_at: :asc },
        name:'index_ideas_author_active_at'
    try_add_index :ideas,          :state
    try_add_index :ideas,          :active_at
    try_add_index :ideas,          :author_id
    try_add_index :ideas,          :product_manager_id

    try_add_index :attachments,    [:owner_type, :owner_id, :uploader_id]
    try_add_index :storage_chunks, :file_id

    change_column :user_roles,    :name,         :string, limit: 24
    change_column :notifications, :subject_type, :string, limit: 16
    change_column :votes,         :subject_type, :string, limit: 16
  end


  def self.down
    remove_index :users,          [:account_id, :id]
    remove_index :vettings,       [:user_id, :idea_id]
    remove_index :vettings,       [:created_at]
    remove_index :votes,          [:subject_type, :user_id, :subject_id]
    remove_index :votes,          [:created_at]
    remove_index :user_roles,     :user_id
    remove_index :user_roles,     [:name, :user_id]
    remove_index :notifications,  name:'index_notifications_on_subject_and_recipient'
    remove_index :user_bookmarks, [:user_id, :idea_id]
    remove_index :comments,       [:idea_id, :author_id]
    remove_index :comments,       name:'index_comments_on_timestamps'
    remove_index :ideas,          name:'index_ideas_author_active_at'
    remove_index :ideas,          :state
    remove_index :ideas,          :active_at
    remove_index :ideas,          :author_id
    remove_index :ideas,          :product_manager_id
    remove_index :attachments,    [:owner_type, :owner_id, :uploader_id]
    remove_index :storage_chunks, :file_id

    change_column :user_roles,    :name,         :string, limit: 255
    change_column :notifications, :subject_type, :string, limit: 255
    change_column :votes,         :subject_type, :string, limit: 255
  end

  private

  class << self
    def try_add_index(*args)
      add_index(*args)
    rescue ArgumentError => e
      return if e.message =~ /Index name .* on table .* already exists/
      raise
    end
  end
end
