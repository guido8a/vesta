<%@ page import="vesta.contratacion.Aprobacion" %>
<!DOCTYPE html>
<html>
<head>
    %{--<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>--}%
    <meta name="layout" content="main"/>
    <title>Reuniones de aprobación</title>
</head>

<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>


<g:set var="editables" value="${['ASPL', 'DP', 'GP']}"/> <!-- Asistente, Director, Gerente de Planificacion son los que pueden editar -->

<div class="dialog" >
    <div class="btn-toolbar toolbar">
        <g:if test="${editables.contains(session.perfil.codigo)}">

            <div class="btn-group">
                <g:link class="button create btn btn-default" action="prepararReunionAprobacion">
                    <i class="fa fa-file-o"></i> Nueva reunión
                </g:link>
                <a href="#" class="button print btn btn-default">
                    <i class="fa fa-print"></i> PDF aprobadas
                </a>
                <g:link controller="reporteSolicitud" action="aprobadasXLS" class="button xls btn btn-default">
                    <i class="fa fa-file-excel-o"></i> XLS aprobadas
                </g:link>
            </div> <!-- toolbar -->

        </g:if>
        <div class="btn-group pull-right col-md-3">
            <div class="input-group input-group-sm">
                <input type="text" class="form-control input-sm input-search" placeholder="Buscar" value="${params.search}">
                <span class="input-group-btn">
                    <g:link controller="aprobacion" action="list" class="btn btn-default btn-search">
                        <i class="fa fa-search"></i>&nbsp;
                    </g:link>
                </span>
            </div><!-- /input-group -->
        </div>
    </div>
    <div class="body">
        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>
        %{--<div class="list">--}%
            <table class="table table-condensed table-bordered table-striped table-hover">
                <thead>
                <tr>
                    <th>N.</th>
                    <th style="width: 450px;">Solicitudes a tratar</th>
                    <g:sortableColumn property="fecha" title="Fecha" />
                    <g:sortableColumn property="observaciones" title="Observaciones" />
                    <g:sortableColumn property="asistentes" title="Asistentes" />
                    <th>Estado</th>
                    %{--<th>Acciones</th>--}%
                </tr>
                </thead>
                <tbody>
                <g:each in="${aprobacionInstanceList}" status="i" var="aprobacionInstance">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" data-id="${aprobacionInstance.id}"
                        data-numero="${aprobacionInstance.numero}" data-objeto="${aprobacionInstance}"
                        data-sol="${aprobacionInstance.solicitudes.size()}" data-aprobada="${aprobacionInstance.aprobada}">
                        <td>${aprobacionInstance.numero}</td>
                        <td>
                            <g:set var="solicitudes" value="${vesta.contratacion.Solicitud.findAllByAprobacion(aprobacionInstance, [sort: 'nombreProceso'])}"/>
                            <g:if test="${solicitudes.size() > 0}">
                                <ul class="ulSolicitudes">
                                    <g:each in="${solicitudes}" var="sol">
                                        <li>
                                            <elm:textoBusqueda busca="${params.search}">
                                            ${sol.unidadEjecutora.nombre} - ${sol.nombreProceso}
                                            </elm:textoBusqueda>
                                        </li>
                                    </g:each>
                                </ul>
                            </g:if>
                            <g:else>
                                - Sin solicitudes -
                            </g:else>
                        </td>
                        <td style="text-align: center">
                            <g:if test="${aprobacionInstance.fecha}">
                                ${aprobacionInstance.fecha.format("dd-MM-yyyy HH:mm")}
                            </g:if>
                            <g:else>
                                <a href="#" class="button btnSmall btnSetFecha btn btn-default" id="${aprobacionInstance.id}">
                                <i class="fa fa-clock-o"></i> Establecer
                                </a>
                            </g:else>
                        </td>
                        <td><${fieldValue(bean: aprobacionInstance, field: "observaciones")}</td>
                        <td>${fieldValue(bean: aprobacionInstance, field: "asistentes")}</td>
                        <td style="text-align: center"><b>${aprobacionInstance.aprobada == 'A' ? 'Aprobada' : 'Pendiente'}</b></td>
                        %{--<td style="text-align: center;">--}%
                            %{--<g:if test="${aprobacionInstance.aprobada != 'A'}">--}%
                                %{--<g:if test="${aprobacionInstance.solicitudes.size() > 0}">--}%
                                    %{--<g:if test="${editables.contains(session.perfil.codigo)}">--}%
                                        %{--<g:link class="button btnSmall" action="reunion" id="${aprobacionInstance.id}">--}%
                                            %{--<g:if test="${!aprobacionInstance.numero}">--}%
                                                %{--Empezar--}%
                                            %{--</g:if>--}%
                                            %{--<g:else>--}%
                                                %{--Continuar--}%
                                            %{--</g:else>--}%
                                        %{--</g:link>--}%
                                    %{--</g:if>--}%
                                    %{--<g:if test="${!aprobacionInstance.numero}">--}%
                                        %{--<g:if test="${editables.contains(session.perfil.codigo)}">--}%
                                            %{--<g:link class="button btnSmall" action="prepararReunionAprobacion" id="${aprobacionInstance.id}">--}%
                                                %{--Preparar--}%
                                            %{--</g:link>--}%
                                        %{--</g:if>--}%
                                    %{--</g:if>--}%
                                %{--</g:if>--}%
                                %{--<g:else>--}%
                                    %{--<g:if test="${editables.contains(session.perfil.codigo)}">--}%
                                        %{--<g:if test="${!aprobacionInstance.numero}">--}%
                                            %{--<g:link class="button btnSmall" action="prepararReunionAprobacion" id="${aprobacionInstance.id}">--}%
                                                %{--Preparar--}%
                                            %{--</g:link>--}%
                                        %{--</g:if>--}%
                                    %{--</g:if>--}%
                                %{--</g:else>--}%
                            %{--</g:if>--}%
                            %{--<g:link class="button btnSmall" action="reunion" id="${aprobacionInstance.id}" params="[show: 1]">--}%
                                %{--Ver--}%
                            %{--</g:link>--}%
                        %{--</td>--}%
                    </tr>
                </g:each>
                </tbody>
            </table>
        <elm:pagination total="${aprobacionInstanceCount}" params="${params}"/>
    </div> <!-- body -->
</div> <!-- dialog -->

<script type="text/javascript">
    $(function () {
        $(".button").button();
        $(".home").button("option", "icons", {primary : 'ui-icon-home'});
        $(".create").button("option", "icons", {primary : 'ui-icon-document'});
        $(".xls").button("option", "icons", {primary : 'ui-icon-note'});

        $("#btnBuscar").button({
            icons : {primary : 'ui-icon-search'},
            text  : false
        }).click(function () {
            var search = $.trim($("#txtBuscar").val());
            location.href = "${createLink(controller: 'aprobacion', action:'list')}?search=" + search;
            return false;
        });
        $("#txtBuscar").keyup(function (ev) {
            if (ev.keyCode == 13) {
                var search = $.trim($("#txtBuscar").val());
                location.href = "${createLink(controller: 'aprobacion', action:'list')}?search=" + search;
            }
        });

        $(".print").button("option", "icons", {primary : 'ui-icon-print'}).click(function () {
            var url = "${createLink(controller: 'reporteSolicitud', action: 'aprobadas')}";
            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=solicitudes.pdf";
            return false;
        });

        $(".btnSetFecha").click(function () {
            var id = $(this).attr("id");

            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'setFechaReunion_ajax')}",
                data    : {
                    id      : id
                },
                success : function (msg) {
                    var b = bootbox.dialog({
                        id    : "dlgFechaReunion",
                        title : "Fecha reunión",

                        message : msg,
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
                                    $.ajax({
                                        type    : "POST",
                                        url     : "${createLink(action: 'saveFechaReunion_ajax')}",
                                        data    : {
                                            id: id,
                                            fecha : $("#fechaReunionId").val()
                                        },
                                        success : function (msg) {
                                            var parts = msg.split("*");
                                            log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                            setTimeout(function() {
                                                if (parts[0] == "SUCCESS") {
                                                    location.reload(true);
                                                } else {
                                                    return false;
                                                }
                                            }, 1000);
                                        }
                                    });
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                    setTimeout(function () {
                        b.find(".form-control").first().focus()
                    }, 500)

                }
            });
        });

        $(".edit").button("option", "icons", {primary : 'ui-icon-pencil'});
        $(".delete").button("option", "icons", {primary : 'ui-icon-trash'}).click(function () {
            if (confirm("${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}")) {
                return true;
            }
            return false;
        });
    });




    function createContextMenu (node) {
        var $tr = $(node);

        var estado = $tr.data("estado");
        var incluir = $tr.data("incluir");
        var detalles = parseInt($tr.data("detalles"));
        var numero = $tr.data("numero");
        var obj = $tr.data("objeto");
        var tamano = $tr.data("sol");
        var apro = $tr.data("aprobada");
        var etiqueta = '';

        var items = {
            header   : {
                label  : "Acciones",
                header : true
            },
            ver      : {
                label  : "Detalles",
                icon   : "fa fa-search",
                action : function ($element) {
                    var id = $element.data("id");
                    location.href="${createLink(action: "reunion")}/?id=" + id
                }
            }
        };
        if(apro != 'A'){
//            if(obj.solicitudes.size() > 0) {
            if(tamano > 0) {
                var icono
                <g:if test="${editables.contains(session.perfil.codigo)}">
                if(!numero){
                    etiqueta = "Empezar";
                    icono = "fa fa-star"
                }else{
                    etiqueta = "Continuar";
                    icono = "fa fa-share"
                }

                items.empezar = {
                    label  : etiqueta,
                    icon   : icono,
                    action : function ($element) {
                        var id = $element.data("id");
                        location.href = "${createLink(action:'reunion')}?id=" + id
                    }
                };
                </g:if>
                if(!numero){
                <g:if test="${editables.contains(session.perfil.codigo)}">
                    items.preparar1 = {
                        label  : "Preparar",
                        icon   : "fa fa-paper-plane",
                        action : function ($element) {
                            var id = $element.data("id");
                            location.href = "${createLink(action:'prepararReunionAprobacion')}?id=" + id
                        }
                    };
                </g:if>
                }
            }else{
                <g:if test="${editables.contains(session.perfil.codigo)}">
                if(!numero){
                    items.preparar2 = {
                        label  : "Preparar",
                        icon   : "fa fa-paper-plane",
                        action : function ($element) {
                            var id = $element.data("id");
                            location.href = "${createLink(action:'prepararReunionAprobacion')}?id=" + id
                        }
                    };
                }
                </g:if>
            }
        }

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





