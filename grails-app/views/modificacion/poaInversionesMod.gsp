<%@ page import="vesta.proyectos.MarcoLogico" contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <script src="${resource(dir: 'js/plugins/fixed-header-table-1.3', file: 'jquery.fixedheadertable.js')}"></script>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'js/plugins/fixed-header-table-1.3/css', file: 'defaultTheme.css')}"/>
    <title>Modificaciones al PAPP del proyecto: ${proyecto?.toStringCompleto()}</title>
</head>

<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>



<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:link class="btn btn-sm btn-default" controller="modificacion" action="poaInversionesMod" id="${proyecto.id}"><i class="fa fa-eraser"></i> Resetear</g:link>


        <b style="margin-left: 50px">Año:</b>
        <g:select from="${vesta.parametros.poaPac.Anio.list([sort:'anio'])}" id="anio_asg" name="anio" optionKey="id" optionValue="anio" value="${actual.id}"/>

    </div>
</div>



<input type="hidden" id="id_origen">
<input type="hidden" id="id_destino">
<fieldset class="ui-corner-all" style="min-height: 110px;font-size: 11px; margin-top: 40px">
    <legend>
        Asignación de origen
    </legend>
    <table class="table table-condensed table-bordered table-striped table-hover">
        <thead>
        <th style="width: 280px">Proyecto</th>
        <th>Actividad</th>
        <th style="width: 60px;">Partida</th>
        <th style="width: 240px">Desc. Presupuestaria</th>

        <th>Fuente</th>
        <th>Presupuesto</th>

        </thead>
        <tbody>

        <tr class="odd" id="tr_origen">
            <td class="proyecto_org">

            </td>

            <td class="actividad_org">

            </td>

            <td class="prsp_org" style="text-align: center">

            </td>

            <td class="desc_org" style="width: 240px">

            </td>

            <td class="fuente_org">

            </td>

            <td class="valor_org" style="text-align: right">

            </td>


        </tr>
        </tbody>
    </table>

</fieldset>
<fieldset class="ui-corner-all" style="min-height: 110px;font-size: 11px;">
    <legend>
        Asignación de destino
    </legend>
    <table class="table table-condensed table-bordered table-striped table-hover">
        <thead>
        <th style="width: 280px">Proyecto</th>
        <th>Actividad</th>
        <th style="width: 60px;">Partida</th>
        <th style="width: 240px">Desc. Presupuestaria</th>

        <th>Fuente</th>
        <th>Presupuesto</th>

        </thead>
        <tbody>

        <tr class="odd" id="tr_dest">
            <td class="proyecto_dest" id="">

            </td>

            <td class="actividad_dest">

            </td>

            <td class="prsp_dest" style="text-align: center">

            </td>

            <td class="desc_dest" style="width: 240px">

            </td>

            <td class="fuente_dest">

            </td>

            <td class="valor_dest" style="text-align: right">

            </td>


        </tr>
        </tbody>
    </table>
</fieldset>

<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <a href="#" class="btn btn-sm btn-default" id="modificar"><i class="fa fa-random"></i> Modificar</a>
        %{--<a href="#" class="btn btn-sm btn-default" id="buscarAsg"><i class="fa fa-search"></i> Buscar Asignación</a>--}%
    </div>
</div>


<fieldset class="ui-corner-all" style="min-height: 100px;font-size: 11px">
    <legend>
        Detalle
    </legend>
    <g:set var="total" value="0"/>
    <table id="tblDetalles" class="table table-condensed table-bordered table-striped table-hover">
        <thead>
        <th >Proyecto</th>
        <th >Componente</th>
        <th>Actividad</th>
        <th style="width: 60px;">Partida</th>
        <th style="width: 240px">Desc. Presupuestaria</th>
        <th>Fuente</th>
        <th>Presupuesto</th>
        <th>Acciones</th>
        </thead>
        <tbody>
        <g:each in="${asignaciones}" var="asg" status="i">
            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" id="det_${i}" pro="${asg?.marcoLogico?.proyecto?.id}" asgn="${asg?.id}" anio="${asg?.anio}">
                <td class="programa">
                    ${asg.marcoLogico?.proyecto}
                </td>
                <td class="actividad">
                    ${asg.marcoLogico.marcoLogico.numeroComp} - ${asg.marcoLogico.marcoLogico}
                </td>
                <td class="actividad">
                    ${asg.marcoLogico.numero} - ${asg.marcoLogico}
                </td>

                <td class="prsp" style="text-align: center">
                    ${asg.presupuesto.numero}
                </td>

                <td class="desc" style="width: 240px">
                    ${asg.presupuesto?.descripcion}
                </td>

                <td class="fuente">
                    ${asg.fuente?.descripcion}
                </td>

                <td class="valor" style="text-align: right">
                    <g:formatNumber number="${asg.priorizado}"
                                    format="###,##0"
                                    minFractionDigits="2" maxFractionDigits="2"/>
                    <g:set var="total" value="${total.toDouble()+asg.priorizado}"/>
                </td>

                <td style="text-align: center">

                    <a href="#" class="btn btn-sm btn-default destino ajax" title="Incremento" iden="${asg.id}" icono="ico_001" clase="act_" band="0" tr="#det_${i}" proy="${asg.marcoLogico?.proyecto}" prsp_id="${asg.presupuesto.id}" prsp_num="${asg.presupuesto.numero}" desc="${asg.presupuesto.descripcion}" fuente="${asg.fuente}" valor="${asg.priorizado}" actv="${asg.marcoLogico}">
                        <i class="fa fa-sort-up"></i>
                    </a>
                    <a href="#" class="btn  btn-sm btn-default origen ajax" iden="${asg.id}" title="Reducción" icono="ico_001" clase="act_" band="0" tr="#det_${i}" proy="${asg.marcoLogico?.proyecto}" prsp_id="${asg.presupuesto.id}" prsp_num="${asg.presupuesto.numero}" desc="${asg.presupuesto.descripcion}" fuente="${asg.fuente}" valor="${asg.priorizado}" actv="${asg.marcoLogico}">
                        <i class="fa fa-sort-desc"></i>
                    </a>

                </td>
                <td class="agr">
                    %{--<g:if test="${actual.estado==0}">--}%
                        <a href="#" class="btn_agregar btn btn-sm btn-default" title="Dividir en dos partidas" asgn="${asg.id}" anio="${actual.id}"><i class="fa fa-scissors"></i></a>
                    %{--</g:if>--}%
                </td>
            </tr>

        </g:each>
        </tbody>
    </table>

    <div style="position: absolute;top:5px;right:10px;font-size: 15px;">
        <b>Total programa actual:</b>
        <g:formatNumber number="${total.toFloat()}"
                        format="###,##0"
                        minFractionDigits="2" maxFractionDigits="2"/>
    </div>

    <div style="position: absolute;top:25px;right:10px;font-size: 15px;">
        <b>Total Unidad:</b>
        <g:formatNumber number="${totalUnidad}"
                        format="###,##0"
                        minFractionDigits="2" maxFractionDigits="2"/>
    </div>

    <div style="position: absolute;top:45px;right:10px;font-size: 15px;">
        <b>M&aacute;ximo Inversión:</b>
        <g:formatNumber number="${maxUnidad}"
                        format="###,##0"
                        minFractionDigits="2" maxFractionDigits="2"/>
    </div>

    <div style="position: absolute;top:65px;right:10px;font-size: 17px;">
        <b>Restante:</b>
        <input type="hidden" id="restante" value="${(maxUnidad - totalUnidad).toFloat().round(2)}">
        <g:formatNumber number="${maxUnidad - totalUnidad}"
                        format="###,##0"
                        minFractionDigits="2" maxFractionDigits="2"/>
    </div>

</fieldset>

<script type="text/javascript">


    $("#tblDetalles").fixedHeaderTable({
        height    : 320,
        autoResize: true,
        footer    : true
    });


    $(function () {
        $("#h_origen").val("")
        $("#h_destino").val("")
        var idOrigen
        var idDestino

        $(".origen").click(function(){
            if($("#id_destino").val()!=$(this).attr("iden")){
                $(".proyecto_org").html($(this).attr("proy"))
                $(".fuente_org").html($(this).attr("fuente"))
                $(".valor_org").html(number_format($(this).attr("valor")*1, 2, ",", "."))
                $(".valor_org").attr("valor",$(this).attr("valor"))
                $(".prsp_org").html($(this).attr("prsp_num"))
                $(".desc_org").html($(this).attr("desc"))
                $("#id_origen").val($(this).attr("iden"))
                $(".actividad_org").html($(this).attr("actv"))
                idOrigen = $(this).attr("iden")
            }else{
                bootbox.alert("La asignaciones de origen y destino no pueden ser la misma")
            }
        });
        $(".destino").click(function(){
            if($("#id_origen").val()!=$(this).attr("iden")){
                $(".proyecto_dest").html($(this).attr("proy"))
                $(".fuente_dest").html($(this).attr("fuente"))
                $(".valor_dest").html(number_format($(this).attr("valor")*1, 2, ",", "."))
                $(".valor_dest").attr("valor",$(this).attr("valor"))
                $(".prsp_dest").html($(this).attr("prsp_num"))
                $(".desc_dest").html($(this).attr("desc"))
                $("#id_destino").val($(this).attr("iden"))
                $(".actividad_dest").html($(this).attr("actv"))
                idDestino = $(this).attr("iden")
            } else{
                bootbox.alert("La asignaciones de origen y destino no pueden ser la misma")
            }
        });

        $("[name=programa]").selectmenu({width:550, height:50})
        $("#programa-button").css("height", "40px")
        $(".btn_arbol").button({icons:{ primary:"ui-icon-bullet"}})
        $(".btn").button()
        $(".back").button("option", "icons", {primary:'ui-icon-arrowreturnthick-1-w'});


        $(".editar").click(function () {
            $("#programa").selectmenu("value", $(this).attr("prog"))
            $("#fuente").val($(this).attr("fuente"))
            $("#valor_txt").val($(this).attr("valor"))
            $("#prsp_id").val($(this).attr("prsp_id"))
            $("#prsp_num").val($(this).attr("prsp_num"))
            $("#desc").html($(this).attr("desc"))
            $("#guardar_btn").attr("iden", $(this).attr("iden"))
            $("#actv").val($(this).attr("actv"))
        });

        $("#anio_asg, #programa").change(function () {
            location.href = "${createLink(controller:'modificacion',action:'poaInversionesMod')}?id=${unidad.id}&anio=" + $("#anio_asg").val() + "&programa=" + $("#programa").val();
            %{--location.href = "${createLink(controller:'modificacion',action:'poaInversionesMod')}?id=${unidad.id}&anio=" + $("#anio_asg").val();--}%
        });


        $("#modificar").click(function(){

            if(!idOrigen){
                log("Seleccione una asignación de origen", "error")
            }if(!idDestino){
                log("Seleccione una asignación de destino", "error")
            }else{
                $.ajax({
                    type: "POST",
                    url: "${createLink(controller:"modificacion", action: "modificar_ajax")}",
                    data: {
                        id: ${proyecto?.id},
                        origen: idOrigen,
                        destino: idDestino

                    },
                    success: function (msg){
                        bootbox.dialog ({
                            id: "dlgModificar",
                            title: "Modificar PAPP",
                            class: "modal-lg",
                            message: msg,
                            buttons : {
                                cancelar : {
                                    label     : "Cancelar",
                                    className : "btn-primary",
                                    callback  : function () {
                                    }
                                },
                                guardar  : {
                                    id        : "btnSave",
                                    label     : "<i class='fa fa-save'></i> Guardar",
                                    className : "btn-success",
                                    callback  : function () {

                                        bootbox.dialog({
                                            id: "dlgAlerta",
                                            title: "Modificar PAPP",
                                            class: "modal-lg",
                                            message: "Esta seguro que desea modificar la asignación?",
                                            buttons : {
                                                cancelar : {
                                                    label     : "Cancelar",
                                                    className : "btn-primary",
                                                    callback  : function () {
                                                    }
                                                },
                                                aceptar : {

                                                    label     : "Aceptar",
                                                    className : "btn-success",
                                                    callback  : function () {
                                                        var monto = $("#monto").val()
                                                        var max = $("#max").attr("valor")*1
                                                        monto = str_replace(".","",monto)
                                                        monto = str_replace(",",".",monto)

                                                        monto = monto*1
                                                        if(monto>max){
                                                            log("El monto debe ser menor a "+number_format(max, 2, ",", "."), "error")
                                                        }else{
                                                            if(monto>0){
                                                                if($("#archivo").val()!=""){
                                                                    $("#load").dialog("open")
                                                                    $("#monto").val(monto)
                                                                    $(".frm_modpoa").submit()
                                                                } else{
                                                                    log("El archivo de autorización es obligatorio.","error")
                                                                }
                                                            }else
                                                                log("El monto debe ser mayor a cero","error")
                                                        }
                                                    }
                                                }
                                            }
                                        });
                                        return false
                                    } //callback
                                } //guardar
                            }
                        })
                    }
                });
            }
        });

        $(".btn_agregar").click(function () {
            var asigna = $(this).attr("asgn");
            var proyec = $(this).attr("pro");
            var anio =   $(this).attr("anio");


        bootbox.dialog ({
            id: "dlgModificar",
            title: "Dividir Asignación",
//            class: "modal-lg",
            message: "Dividir esta asignación con otra partida?",
            buttons : {
                cancelar: {
                    label: "Cancelar",
                    className: "btn-primary",
                    callback  : function () {
                    }
                },
                aceptar :{
                    label: "Aceptar",
                    className: "btn-success",
                    callback  : function () {
                        $.ajax({
                            type:"POST", url:"${createLink(action:'agregaAsignacionMod', controller: 'asignacion')}",
                            data:"id=" + asigna + "&proy=" + proyec + "&anio=" + anio + "&unidad=${unidad.id}",
                            success:function (msg) {

                                bootbox.dialog({
                                    id: "dlgModificar",
                                    title: "Dividir Asignación",
//                                    class: "modal-lg",
                                    message: msg,
                                    buttons : {
                                        cancelar: {
                                            label: "Cancelar",
                                            className: "btn-primary",
                                            callback  : function () {
                                            }
                                        },
                                        aceptar : {
                                            label: "<i class='fa fa-search'></i> Aceptar",
                                            className: "btn-success",
                                            callback  : function () {
                                                var asgn = $('#padre').val()
                                                var mxmo = parseFloat($('#maximo').val());
                                                var valor = str_replace(",", "", $('#vlor').val());
                                                valor = parseFloat(valor);
                                                $('#vlor').val(valor)
                                                if (valor > mxmo) {
                                                    log("La nueva asignación debe ser menor a " + mxmo, "error")
                                                } else {
                                                    var partida = $('#prsp2').val()
                                                    var fuente = $('#fuente').val();
                                                    $(".frmModAsignaciones").submit()
                                                }
                                            }
                                        }
                                    }

                                });
                            }
                        });

                    }
                }
            }
        });
        });





        $(".btn_borrar").button({
            icons:{
                primary:"ui-icon-trash"
            },
            text:false
        }).click(function () {
            //alert ("id:" +$(this).attr("asgn"))
            if (confirm("Eliminar esta asignación: \n Su valor se sumará a su asignación original y\n la programación deberá revisarse")) {
                $.ajax({
                    type:"POST", url:"${createLink(action:'borrarAsignacion', controller: 'asignacion')}",
                    data:"id=" + $(this).attr("asgn"),
                    success:function (msg) {
                        location.reload(true);
                    }
                });
            }
        });


//        $("#ajx_asgn").dialog({
//            autoOpen:false,
//            resizable:false,
//            title:'Crear un Perfil',
//            modal:true,
//            draggable:true,
//            width:480,
//            height:300,
//            position:'center',
//            open:function (event, ui) {
//                $(".ui-dialog-titlebar-close").hide();
//            },
//            buttons:{
//                "Grabar":function () {
//                    var asgn = $('#padre').val()
//                    var mxmo = parseFloat($('#maximo').val());
//                    var valor = str_replace(".", "", $('#vlor').val());
//                    valor = str_replace(",", ".", valor);
//                    valor = parseFloat(valor);
//                    $('#vlor').val(valor)
//                    //alert("Valores: maximo " + mxmo + " valor: " + valor);
//                    if (valor > mxmo) {
//                        alert("La nueva asignación debe ser menor a " + mxmo);
//                    } else {
//                        var partida = $('#prsp2').val()
//                        var fuente = $('#fuente').val();
//                        $(this).dialog("close");
//                        $(".frmModAsignaciones").submit()
//                    }
//                },
//                "Cancelar":function () {
//                    $(this).dialog("close");
//                }
//            }
//        });



        ////////////////////////////////////**********BUSCADOR************////////////////////////////

        $("#buscarAsg").click(function () {

//            $("#buscarAsg_dlg").dialog("open")
            $.ajax({
                type: "POST",
                url: "${createLink(controller:"modificacion", action: "buscarAsg_ajax")}",
                data: {
                    id: ${proyecto?.id}
                },
                success: function (msg){
                    bootbox.dialog ({
                        id: "dlgBuscarAsg",
                        title: "Buscar Asignaciones",
//                        class: "modal-lg",
                        message: msg,
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            },
                            guardar  : {
                                id        : "btnSave",
                                label     : "Aceptar",
                                className : "btn-success",
                                callback  : function () {
                                    $.ajax({
                                        type:"POST",
                                        url:"${createLink(action:'buscarAsignacionInversion',controller:'modificacion')}",
                                        data:"unidad=" + $("#unidadAsg").val() + "&partida=" + $("#prsp2").val()+"&anio=${actual.id}",
                                        success:function (msg) {
                                            $("#resultadoAsg").html(msg)
                                        }
                                    });

                                } //callback
                            } //guardar
                        }
                    })
                }
            });
        });





        %{--$("#btn_buscarAsg").click(function () {--}%
        %{--$.ajax({--}%
        %{--type:"POST",--}%
        %{--url:"${createLink(action:'buscarAsignacionInversion',controller:'modificacion')}",--}%
        %{--data:"unidad=" + $("#unidadAsg").val() + "&partida=" + $("#prsp2").val()+"&anio=${actual.id}",--}%
        %{--success:function (msg) {--}%
        %{--$("#resultadoAsg").html(msg)--}%
        %{--}--}%
        %{--});--}%
        %{--});--}%


//        $("#buscarAsg_dlg").dialog({
//            title:"Busqueda de asignaciones",
//            width:900,
//            height:600,
//            autoOpen:false,
//            modal:true
//        })


    });


//    $(".buscar").click(function () {
//        $("#id_txt").val($(this).attr("id"))
//        $("#buscar").dialog("open")
//    });

    %{--$("#btn_buscar").click(function () {--}%
    %{--$.ajax({--}%
    %{--type:"POST",--}%
    %{--url:"${createLink(action:'buscarPresupuesto',controller:'asignacion')}",--}%
    %{--data:"parametro=" + $("#par").val() + "&tipo=" + $("#tipo").val(),--}%
    %{--success:function (msg) {--}%
    %{--$("#resultado").html(msg)--}%
    %{--}--}%
    %{--});--}%
    %{--});--}%

    //    $("#buscar").dialog({
    //        title:"Cuentas presupuestarias",
    //        width:520,
    //        height:500,
    //        autoOpen:false,
    //        modal:true
    //    })





</script>

</body>
</html>