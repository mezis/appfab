# 
# Sets up uploaders.
# 
$.unobtrusive () ->
  $('[data-uploader]').each () ->
    # debugger
    uploader_template = $(this).attr('data-template-uploader')
    file_template     = $(this).attr('data-template-file')
    parent            = $(this).attr('data-parent')
    refresh_endpoint  = $(this).attr('data-refresh-endpoint')
    refresh_target    = $(this).attr('data-refresh-target')
    upload_endpoint   = $(this).attr('data-upload-endpoint')

    uploader = new qq.FineUploader
      debug:              true
      # element:            document.getElementById($(this).attr('id'))
      element:          this
      classes:
        success:          'alert alert-success'
        fail:             'alert alert-error'
      template:           uploader_template
      fileTemplate:       file_template
      dragAndDrop:
        extraDropzones:   $("##{parent} .af-drop-area")
      request:
        endpoint:         upload_endpoint
        customHeaders:
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
        forceMultipart:   true
        inputName:        'attachment[file]'
      validation:
        allowedExtensions: ['jpg', 'jpeg', 'png', 'txt', 'md', 'rtf', 'csv', 'doc', 'docx', 'xls', 'xlsx', 'pdf', 'ods', 'odt']
        sizeLimit:         6000000
      callbacks:
        onComplete: (id, name, data) ->
          $(refresh_target).load(refresh_endpoint)
          if data.success
            $(this).find('.qq-upload-list li').eq(id).fadeOut()
