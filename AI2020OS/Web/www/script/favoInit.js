 $(function(){
    var loading = '<div class="loading fixed" style="margin-left:0"><i class="icon-loading"></i></div>',
        tc = '<div class="nodata">没有查找到数据！</div>';
    var comb = $('#combined');
    function initial(handle) {
         $.ajax({
            url: '/favorite/getFavoriteList/' + $('#favoriteId').val(),
            cache: false,
            timeout: 5000,
            success: function(data){
                handle(data);
            },
            error: function(xhr, status, error){
                alert('error ' + status + " " + error);  
            }
        });
    }
    function renderTemplate(context){
        var source = $('#favoTemplate').html(),
            temp = Handlebars.compile(source),
            dataTemp = '';
            dataTemp = temp(context);
        return dataTemp;
    }
    $('#myBtns').delegate('#doExchange', 'click', function(event) {
            $('body').append(loading);
            initial(function(output){
                var out = output;
                if(out.items.length>0){
                    setTimeout(function(){
                        var temp = renderTemplate(out);
                        $('.loading').remove();
                        comb.html('').append(temp);
                    },500)
                }else{
                     setTimeout(function(){
                         $('.loading').remove();
                        comb.html('').append(tc);
                     },500)    
                }
            })
    })
})