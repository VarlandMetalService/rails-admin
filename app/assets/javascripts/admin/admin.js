function flash(partial){
  $('.alert').remove();
  $('#wrapper').prepend(partial);
}

function admin_sort(attribute){
  id = $(event.target).attr('id')
  inc = $(`.admin_btn[data-model='${$(event.target).data('model')}']`).data('includes')
  if (inc == null){
  } else {
    inc = JSON.parse(JSON.stringify(inc))
  }
  if($(event.target).hasClass('sort_down')){
    s_by = " "
    s_how = " "
    cls = ''
  } else {
    s_by = attribute
    if($(event.target).hasClass('sort_up')){
      s_how = "desc"
      cls = 'sort_down'
    } else {
      s_how = "asc"
      cls = 'sort_up'
    }
  }
  $.ajax({
    beforeSend: function(xhr) {
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        },
      complete: function(xhr) {
        $('#content_area').fadeIn();
        if(cls == ""){
        } else {
          $(`#${id}`).addClass(cls)
        }
      },
    url: $(event.target).data('path'),
    data: { model: $(event.target).data('model'),
         includes: inc,
          sort_by: s_by,
         sort_how: s_how,
            where: $('#where_storage').data('where'),
            class: cls,
            format: 'js'}
  })  
}

$(document).on('click','.collapse-btn', {} ,function(e){
  collapsed = $(this).hasClass('collapsed')
  if (collapsed){
    $(this).text('[ + ]');
  }
  else{
    $(this).text('[ - ]');
  }
});