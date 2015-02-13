<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 13/02/15
  Time: 01:23 PM
--%>

<%@ page import="vesta.contratacion.Solicitud" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Preparar reunión de aprobación</title>
    <g:set var="width" value="1000"/>
</head>

<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<div class="dialog">
    <div class=" btn-toolbar toolbar" >
        <div class="btn-group">
            <g:link action="list" class="btnList btn btn-default">
                <i class="fa fa-bars"></i> Lista de reuniones
            </g:link>
            <a href="#" id="btnReunion" class="btn btn-default">
                <i class="fa fa-calendar"></i> Ingresar la revisión de la DPI y Agendar reunión
            </a>
        </div>
    </div> <!-- toolbar -->
    <div class="body">
        <div class="list">
            <table border="1" class="table table-condensed table-bordered table-striped table-hover">
                <thead>
                <tr>
                    <g:sortableColumn property="unidadEjecutora" title="Unidad Ejecutora"/>
                    <g:sortableColumn property="actividad" title="Actividad"/>
                    <g:sortableColumn property="fecha" title="Fecha"/>
                    <g:sortableColumn property="montoSolicitado" title="Monto Solicitado"/>
                    <g:sortableColumn property="tipoContrato" title="Modadlidad de contratación"/>
                    <g:sortableColumn property="nombreProceso" title="Nombre del proceso"/>
                    <g:sortableColumn property="plazoEjecucion" title="Plazo de ejecución"/>
                    <g:sortableColumn property="aprobacion" title="Reunión Aprobación"/>
                    <th>Agendar</th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${solicitudInstanceList}" status="i" var="solicitudInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" data-id="${solicitudInstance?.aprobacion?.id}">
                        <td>${solicitudInstance.unidadEjecutora?.nombre}</td>
                        <td>${solicitudInstance.actividad?.objeto}</td>
                        <td>${solicitudInstance.fecha?.format('dd-MM-yyyy')}</td>
                        <td><g:formatNumber number="${solicitudInstance.montoSolicitado}" type="currency"/></td>
                        <td>${solicitudInstance.tipoContrato?.descripcion}</td>
                        <td>${solicitudInstance.nombreProceso}</td>
                        <td><g:formatNumber number="${solicitudInstance.plazoEjecucion}" maxFractionDigits="0"/> días</td>
                        <td>
                            <g:if test="${solicitudInstance.aprobacion}">
                                <g:if test="${solicitudInstance.aprobacion.fecha}">
                                    ${solicitudInstance.aprobacion.fecha?.format("dd-MM-yyyy HH:mm")}
                                </g:if>
                                <g:else>
                                    Reunión sin fecha establecida
                                </g:else>
                            </g:if>
                            <g:else>
                                No agendado
                            </g:else>
                        </td>
                        <td style="text-align: center;">
                            <g:set var="checked" value="${solicitudInstance.aprobacionId && solicitudInstance.aprobacionId == reunion?.id}"/>
                            <div id="${solicitudInstance.id}" class="check ${checked ? 'checked original' : ''} ui-corner-all">
                                <span class="fa fa-2x ${checked ? 'fa-check-square' : 'fa-square-o'}"></span>
                            </div>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
            <elm:pagination total="${solicitudInstanceTotal}" params="${params}"/>
        </div>
    </div> <!-- body -->
</div> <!-- dialog -->

<script type=" text/javascript">
    function validarSols() {
        var ids = "";
        $(".checked").each(function () {
            ids += $(this).attr("id") + "_";
        });
        if (ids == "") {
            $("#dlgAgendar").dialog("close");
            $.box({
                imageClass : "box_info",
                title      : "Alerta",
                text       : "Seleccione al menos una solicitud para agendar en la reunión",
                iconClose  : false,
                dialog     : {
                    resizable     : false,
                    draggable     : false,
                    closeOnEscape : false,
                    buttons       : {
                        "Aceptar" : function () {
                        }
                    }
                }
            });
        }
        return ids;
    }
    $(function () {

        $(".check").click(function () {
            var $div = $(this);
            if (!$div.hasClass("original")) {
                var $check = $div.find("span");
                if ($check.hasClass("fa-check-square")) {
                    $check.removeClass("fa-check-square").addClass("fa-square-o");
                    $div.removeClass("checked");
                } else if ($check.hasClass("fa-square-o")) {
                    $check.removeClass("fa-square-o").addClass("fa-check-square");
                    $div.addClass("checked");
                }
            }
        });

        $(".datepicker").datepicker({
            changeMonth : true,
            changeYear  : true,
            dateFormat  : 'dd-mm-yy',
            minDate     : "+0"
        });

        $(".btnList").button({
            icons : {
                primary : "ui-icon-clipboard"
            }
        });
        $("#btnReunion").button({
            icons : {
                primary : "ui-icon-note"
            }
        }).click(function () {
            var ids = validarSols();
            if (ids != "") {
                var id = "${reunion?.id}";

                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'agendarReunion_ajax')}",
                    data    : {
                        id  : id,
                        ids : ids
                    },
                    success : function (msg) {
                        $.box({
                            id         : 'dlgAgendar',
                            imageClass : false,
                            title      : "Agendar reunión - Revisión",
                            text       : msg,
                            dialog     : {
                                position : "top",
                                width    : 700,
                                buttons  : {
                                    "Aceptar"  : function (r) {
                                        $("#dlgReunion").dialog("close");
                                        $.box({
                                            imageClass    : "box_info",
                                            title         : "Espere",
                                            text          : "Por favor espere",
                                            iconClose     : false,
                                            closeOnEscape : false,
                                            dialog        : {
                                                resizable     : false,
                                                draggable     : false,
                                                closeOnEscape : false,
                                                buttons       : null
                                            }
                                        });
                                        var data = {
                                            fecha   : $.trim($("#fechaReunion").val()),
                                            horas   : $("#horaReunion").val(),
                                            minutos : $("#minutoReunion").val()
                                        };
                                        data["id"] = id;
                                        $(".txtRevision").each(function () {
                                            data[$(this).attr("name")] = $(this).val();
                                        });
//                                                console.log(data);
                                        $.ajax({
                                            type    : "POST",
                                            url     : "${createLink(action: 'agendarReunion')}",
                                            data    : data,
                                            success : function (msg) {
                                                //                                    console.log(msg);
                                                location.href = "${createLink(action: 'list')}";
                                            }
                                        });
                                    },
                                    "Cancelar" : function () {
                                    }
                                }
                            }
                        });
                    }
                });
            }
            return false;
        });
    });

    function showDetalles (id) {
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'detalles_ajax')}/?id=" + id,
            id    : id,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgDetalles",
                    title   : "Detalles de la reunión de aprobación",
                    class   : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        borrar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-trash'></i> Eliminar",
                            className : "btn-danger",
                            callback  : function () {
                                return submitForm();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    }


    function createContextMenu (node) {
        var $tr = $(node);
        var id = $tr.data("id");
        var items = {
            header   : {
                label  : "Acciones",
                header : true
            },
            ver      : {
                label  : "Detalles",
                icon   : "fa fa-search",
                action : function ($element) {
                    showDetalles(id)
                }
            }
        };

        return items
    }

    $("tbody>tr").contextMenu({
        items  : createContextMenu,
        onShow : function ($element) {
            $element.addClass("success");
        },
        onHide : function ($element) {
            $(".success").removeClass("success");
        }
    });


</script>

</body>
</html>
