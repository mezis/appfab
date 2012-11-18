module AttachmentsHelper

  def attachment_type(attachment)
    attachment.name.split(/\./).last
  end
end
