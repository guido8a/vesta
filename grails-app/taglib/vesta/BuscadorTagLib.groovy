package vesta

class BuscadorTagLib {

    static namespace = 'bsc'

    def operacion = {atr ->

        //println "atr 2 "+atr
        def propiedad = atr.propiedad
        def registro = atr.registro
        def operacion = atr.funcion.keySet().toArray().getAt(0)
        def parametros = atr.funcion[operacion].clone()
        //println " reg "+registro+" op "+operacion+" par "+parametros+" prop "+propiedad
        parametros.eachWithIndex {it, i ->
            if (it == "?")
                parametros[i] = registro[propiedad]
            if (it == "&")
                parametros[i] = registro
        }
        def result
        if (operacion != "closure") {
            switch (parametros.size()) {
                case 1:
                    result = registro[propiedad]?."$operacion"(parametros[0])
                    break
                case 2:
                    result = registro[propiedad]?."$operacion"(parametros[0], parametros[1])
                case 3:
                    result = registro[propiedad]?."$operacion"(parametros[0], parametros[1], parametros[2])
                    break
                default:
                    result = ""
            }
        } else {
//            println "closure "+parametros[0]
            def cl = parametros[0]
            parametros.remove(0)
            result = cl parametros[0]
        }

        //println "return "+result
        //println "----------------------------"
        out << result
    }

    def buscador = {atr ->
        def name = atr.name ? atr.name : " "
        def value = atr.value
        def campos
        campos = atr.campos
        def controlador = atr.controlador
        def accion = atr.accion
        def tipo = atr.tipo
        out<<buscadorReload(atr.name,value,campos,controlador,accion,tipo,atr.id,atr.titulo,atr.clase,atr.style)
        //println "accion " + accion + "    controlador " + controlador

    }

    def buscadorReload(name,value,fields,controller,action,type,id,title,clase,style){
        def salida = ""
        salida+='<span class="grupo">'
        salida+='<div class="input-group input-group-sm" style="'+(style?style:'width:294px;') +'">'
        salida+='<input type="text" class="form-control bsc_desc '+clase+'" id="bsc-desc-'+id+'"  dialog="modal-'+id+'"  >'
        salida+='<span class="input-group-btn">'
        salida+='<a href="#" id="btn-abrir-'+id+'" class="btn btn-info" title="Buscar"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></a>'
        salida+='</span>'
        salida+='</div>'
        salida+=' </span>'
        salida+='<input type="hidden"  id="'+id+'" class="bsc_id " name="'+name+'" value="'+value+'" >'
        salida+='<div class="modal fade modal-search " id="modal-'+id+'" tabindex="-1" role="dialog" aria-labelledby="buscador-'+id+'" aria-hidden="true" >'
        salida +='<div class="modal-dialog long">\n' +
                '<div class="modal-content">\n' +
                '<div class="modal-header">'
        salida+=' <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
        salida+=' <h4 class="modal-title" id="buscador-'+id+'">'+title+'</h4></div>'
        salida+='<div class="modal-body" id="body-buscador">'

        /*Body*/

        salida += '<div class="row" style="margin-top:0px;padding-left:20px">'
//        salida += '<div id="campo" class="campoBuscador">'
        salida += '<b>Buscar por:</b> <select name="campo" id="campo" class=" form-control comboBuscador input-sm " style="width: 130px;font-size:12px;display:inline-block" >'
        def i = 0
        fields.each {
            if (i == 0)
                salida += ' <option value="' + it.key + '" tipo="' + it.value.get(1) + '" selected>' + it.value.get(0) + '</option>'
            else
                salida += ' <option value="' + it.key + '" tipo="' + it.value.get(1) + '">' + it.value.get(0) + '</option>'
            i++
        }
        salida += '</select>'
//        salida += '</div>'
//        salida += '<div id="Doperador"  class="operadorBuscador">'
        salida += '<select name="operador" class="input-sm form-control comboBuscador" style="width: 100px;display:inline-block;margin:5px" id="operador"></select>'
//        salida += '</div>'
        salida += '<input type="hidden" name="tipoCampo" id="tipoCampo" value="string" style=";display:inline-block">'
        salida += '<b>Criterio:</b><input type="text" size="8"  class=" input-sm form-control notBlock" style="margin-right:5px; width:190px;margin-left:5px;;display:inline-block" name="criterio" id="criterio">'
        salida += '<b>Ordenado por:</b><select name="campoOrdn"  class="input-sm form-control comboBuscador" id="campoOrdn" style="width: 100px;font-size:12px;margin:5px;display:inline-block" >'

        i = 0
        fields.each {
            if (i == 0)
                salida += ' <option value="' + it.key + '" tipo="' + it.value.get(1) + '" selected>' + it.value.get(0) + '</option>'
            else
                salida += ' <option value="' + it.key + '" tipo="' + it.value.get(1) + '">' + it.value.get(0) + '</option>'
            i++
        }
        salida += '</select>'
        salida += '<select name="orden" id="orden" class="input-sm form-control comboBuscador" style="width:70px;display:inline-block" ><option value="asc" selected>Asc.</option><option value="desc">Desc.</option></select>'
        salida += '<a href="#" title="Agregar" id="mas" class="btn  btn-default btn-xs" style="margin:5px"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></a>'
        salida += '<a href="#" title="Resetear" id="reset" class="btn  btn-default btn-xs" style="margin-rigth:5px"><span class="glyphicon glyphicon-refresh" aria-hidden="true" ></span></a>'
        salida += '<a href="#" title="Buscar" id="buscarDialog" class="btn  btn-info btn-xs" style="margin-left:5px">Buscar</a>'
        salida += '</div>'
        salida += '<div id="criterios" style="width:95%;height:35px;float:left"></div>'
        salida += '<div class="contenidoBuscador  ui-corner-all" id="contenidoBuscador" style="float:left;width:95%;margin-top:5px;margin-left:10px;overflow-y:auto;min-height: 200px;"></div>'
        salida += '<a href="#" id="btn_reporte" class="btn btn-default btn-xs" style="margin:10px;margin-left:10px"><i class="fa fa-file-pdf-o"></i>Reporte</a>'
        salida += '<a href="#" id="btn_excel"  class="btn btn-default btn-xs" style="margin-left:10px;"><i class="fa fa-file-excel-o"></i>Excel</a>'
        /*body*/

        salida+='</div>'
        salida+='    <div class="modal-footer">\n' +
                '        <a href="#"  class="btn btn-default" data-dismiss="modal">Cancelar</a>\n'+
                '    </div>'

        salida+='</div></div></div>'

        /*JS*/
        salida += "<script type='text/javascript' src='${createLinkTo(dir: 'js', file: 'buscador.js')}' ></script>"
        salida += "<script type='text/javascript'>"
        salida += 'function enviar() {'
        salida += 'var data = "";'
        salida += 'openLoader();'
        salida += '$(".crit").each(function(){'
        salida += 'data+="&campos="+$(this).attr("campo");'
        salida += 'data+="&operadores="+$(this).attr("operador");'
        salida += 'data+="&criterios="+$(this).attr("criterio");'
        salida += '});'
        salida += 'if(data.length<2){'
        salida += 'data="tc="+$("#tipoCampo").val()+"&campos="+$("#campo :selected").val()+"&operadores="+$("#operador :selected").val()+"&criterios="+$("#criterio").val()'
        salida += '}'
        salida += 'data+="&ordenado="+$("#campoOrdn :selected").val()+"&orden="+$("#orden :selected").val();'
        if (controller) {
            salida += '$.ajax({type: "POST",url: "' + g.createLink(controller: controller,action: action) + '",'
        } else {
            salida += '$.ajax({type: "POST",url: "' + g.createLink(action: action) + '",'
        }
        salida += 'data: data,'
        salida += 'success: function(msg){'
        salida += '$(".contenidoBuscador").html(msg).show("slide");'
        salida += 'closeLoader();'
        salida += '}'
        salida += '});'
        salida += '};'
        salida += 'cambiaOperador();'
        salida += '$("#buscarDialog").click(function(){'
        salida += ' enviar();'
        salida += '});'
        salida += '$(".filaBuscador ").keyup(function(e){'
        salida += 'if(e.which == 13) { '
        salida += ' $("#buscarDialog").click();'
        salida += ' }'
        salida += '});'
        salida += '$("#mass-container").prepend($("#modal-'+id+'"));bringToTop($("#modal-'+id+'"));'
        salida += '$("#btn-abrir-'+id+'").click(function(){$("#modal-'+id+'").modal("show")});'
        salida += '</script>'
    }


    def lista(name, value, campos, controlador, accion) {
        def salida = ""
        salida += '<div  class="container-buscador ui-corner-all">'
        salida += '<div class="row ">'
        salida += '<div id="campo" class="campoBuscador">'
        salida += 'Buscar por: <select name="campo" id="campo" class="many-to-one form-control comboBuscador" style="width: 110px;font-size:12px;" >'
        def i = 0
        campos.each {
            if (i == 0)
                salida += ' <option value="' + it.key + '" tipo="' + it.value.get(1) + '" selected>' + it.value.get(0) + '</option>'
            else
                salida += ' <option value="' + it.key + '" tipo="' + it.value.get(1) + '">' + it.value.get(0) + '</option>'
            i++
        }
        salida += '</select>'
        salida += '</div>'
        salida += '<div id="Doperador"  class="operadorBuscador">'
        salida += '<select name="operador" class="many-to-one form-control comboBuscador" style="width: 100px;" id="operador"></select>'
        salida += '</div>'
        salida += '<input type="hidden" name="tipoCampo" id="tipoCampo" value="string">'
        salida += 'Criterio:<input type="text" size="8"  class="form-control notBlock" style="margin-right:5px; width:140px;margin-left:5px;" name="criterio" id="criterio">'
        salida += 'Ordenado por: <select name="campoOrdn"  class="many-to-one form-control comboBuscador" id="campoOrdn" style="width: 100px;font-size:12px;" >'
        i = 0
        campos.each {
            if (i == 0)
                salida += ' <option value="' + it.key + '" tipo="' + it.value.get(1) + '" selected>' + it.value.get(0) + '</option>'
            else
                salida += ' <option value="' + it.key + '" tipo="' + it.value.get(1) + '">' + it.value.get(0) + '</option>'
            i++
        }
        def url = resource(dir: 'images', file: 'spinner_24.gif')
        salida += '</select>'
        salida += '<select name="orden" id="orden" class="many-to-one form-control comboBuscador" style="width:70px" ><option value="asc" selected>Asc.</option><option value="desc">Desc.</option></select>'
//        salida += '<a href="#" id="mas" style="margin-left:5px">Agregar condición</a>'
        salida +='<a class="btn btn-small btn-primary" style="margin-left:5px" href="#" rel="tooltip" title="Agregar" id="mas">'
        salida +=' <i class="fa fa-plus"></i>'
        salida +='</a>'
//        salida += '<a href="#" id="reset" style="margin-left:5px">Resetear</a>'
        salida +='<a class="btn btn-small btn-primary" style="margin-left:5px" href="#" rel="tooltip" title="Resetear" id="reset">'
        salida +=' <i class="fa fa-refresh"></i>'
        salida +='</a>'
        salida += '<a href="#" id="buscarDialog" style="width:80px;margin-left:10px" class="btn btn-small btn-azul " >Buscar'
        salida += '</div>'
        salida += '<div id="criterios" style="width:95%;height:35px;float:left"></div>'
        salida += '<div class="contenidoBuscador  ui-corner-all" id="contenidoBuscador" style="float:left;width:95%;margin-top:5px;margin-left:20px;overflow-y:auto"></div>'
        salida += '<a href="#" id="btn_reporte" style="margin:10px;margin-left:20px;color:white">Reporte</a>'
        salida += '<a href="#" id="btn_excel" style="margin:10px;margin-left:20px;color:white">Excel</a>'
        salida += '</div>'
        salida += "<script type='text/javascript' src='${createLinkTo(dir: 'js', file: 'buscador.js')}' ></script>"
//        salida += "<script type='text/javascript' src='${createLinkTo(dir: 'js/jquery/plugins', file: 'jquery.livequery.js')}' ></script>"
        salida += "<script type='text/javascript'>"

        salida += 'function enviar() {'
        salida += 'var data = "";'
        salida += 'openLoader();'
        salida += '$(".crit").each(function(){'
        salida += 'data+="&campos="+$(this).attr("campo");'
        salida += 'data+="&operadores="+$(this).attr("operador");'
        salida += 'data+="&criterios="+$(this).attr("criterio");'
        salida += '});'
        salida += 'if(data.length<2){'
        salida += 'data="tc="+$("#tipoCampo").val()+"&campos="+$("#campo :selected").val()+"&operadores="+$("#operador :selected").val()+"&criterios="+$("#criterio").val()'
        salida += '}'
        salida += 'data+="&ordenado="+$("#campoOrdn :selected").val()+"&orden="+$("#orden :selected").val();'
        if (controlador) {
            salida += '$.ajax({type: "POST",url: "' + g.createLink(controller: controlador,action: accion) + '",'
        } else {
            salida += '$.ajax({type: "POST",url: "' + g.createLink(action: accion) + '",'
        }

        salida += 'data: data,'

        salida += 'success: function(msg){'
        salida += '$(".contenidoBuscador").html(msg).show("slide");'
        salida += 'closeLoader();'
        salida += '}'
        salida += '});'
        salida += '};'
        salida += 'cambiaOperador();'
        salida += '$("#buscarDialog").click(function(){'
        salida += ' enviar();'
        salida += '});'
        salida += '$(".filaBuscador ").keyup(function(e){'
        salida += 'if(e.which == 13) { '
        salida += ' $("#buscarDialog").click();'
        salida += ' }'
        salida += '});'




        salida += '</script>'

        return salida
    }



}
