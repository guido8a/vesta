<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 19/01/15
  Time: 12:32 PM
--%>

<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Firmas pendientes</title>
</head>

<body>
<g:if test="${session.perfil.codigo == 'DRRQ'}">
    <div class="btn-toolbar toolbar">
        <div class="btn-group">
            <div class="fila" style="height: 35px;">
                <g:link controller="avales" action="listaProcesos" class="btn btn-default">Ver Solicitudes de Avales</g:link>
                <g:link controller="modificacionesPoa" action="historialUnidad" class="btn btn-default">Ver Solicitudes de Reformas al POA</g:link>
            </div>
        </div>
    </div>
</g:if>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<div role="tabpanel" style="margin-top: 50px">

    <ul class="nav nav-tabs" role="tablist">
        <li role="presentation" class="active"><a href="#solicitudes" class="btn-default active" role="tab" data-toggle="tab">Firmas Pendientes</a></li>
        <li role="presentation"><a href="#historial" class="btn-default" role="tab" data-toggle="tab">Historial</a></li>
    </ul>

    <div class="tab-content">
        <div class="tab-pane fade in active" id="solicitudes">
            <g:if test="${firmas.size() > 0}">
                <table class="table table-condensed table-bordered table-striped table-hover">
                    <thead>
                    <tr>
                        <th>Concepto</th>
                        <th>Documento</th>
                        <th>Acciones</th>
                        %{--<th>Firmar</th>--}%
                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${firmas}" var="f">
                        <tr data-firma="${f}" esPdf="${f.esPdf}" accVer="${f.accionVer}">
                            <td>${f.concepto}</td>
                            <td>${f.documento}</td>
                            <td style="text-align: center">
                                <g:if test="${f.accionVer}">
                                    <g:if test="${f.esPdf != 'N'}">
                                        <a href="${g.createLink(controller: 'pdf', action: 'pdfLink')}?url=${g.createLink(action: f.accionVer, controller: f.controladorVer, id: f.idAccionVer)}" target="_blank" class="btn btn-info btn-sm" style="margin: 5px"> <i class="fa fa-search"></i> Ver</a>
                                    </g:if>
                                    <g:else>
                                        <a href="${g.createLink(action: f.accionVer, controller: f.controladorVer, id: f.idAccionVer)}" target="_blank" class="btn btn-info btn-sm" style="margin: 5px"><i class="fa fa-search"></i> Ver</a>
                                    </g:else>
                                </g:if>
                                <a href="#" iden="${f.id}" class="aprobar btn btn-success btn-sm" style="margin: 5px"><i class="fa fa-paw"></i> Firmar</a>
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </g:if>
        </div>
        <div role="tabpanel" class="tab-pane fade" id="historial">
            <div class="fila">
                <span class="grupo">
                <label> Año: </label>
                <div>
                <g:select name="anioName" from="${vesta.parametros.poaPac.Anio.list([sort: 'anio'])}" optionKey="id" optionValue="anio" id="anio" style="width:100px" class="form-control input-sm" value="${actual?.id}"/>
                </div>
                </span>
            </div>
            <div id="detalle" style="width: 100%;height: 500px;overflow: auto"></div>
        </div>
    </div>
</div>

<div id="firmarDlg">
    <div class="fila">
        <div class="labelSvt" style="width:150px;height: 45px">
            Clave de
            autorización
        </div>

        <div class="fieldSvt-medium" style="height: 45px">
            <input type="password" id="atrz" style="">
        </div>
    </div>
</div>

<div id="negar">
    <input type="hidden" id="avalId">
    Esta seguro que desea negar esta solicitud de certificación?
</div>
<script>
    function cargarHistorial(anio) {

        $.ajax({
            type    : "POST", url : "${createLink(action:'historial', controller: 'firma')}",
            data    : {
                anio : anio
            },
            success : function (msg) {
                $("#detalle").html(msg)

            }
        });

    }
    cargarHistorial($("#anio").val())
    $("#anio").change(function () {
        cargarHistorial($("#anio").val())
    })

    $(".btn").button()

    $(".descRespaldo").click(function () {
        location.href = "${createLink(controller:'avales',action:'descargaSolicitud')}/" + $(this).attr("iden")

    });

    $("#tabs").tabs()
    var id

    $(".aprobar").button({icons : { primary : "ui-icon-check"}, text : false}).click(function () {
        id = $(this).attr("iden")
        if (confirm("Está seguro? esta acción no puede revertirse")) {
            +$("#atrz").val("")
            $("#firmarDlg").dialog("open")
        }
    });

//
//    function aprobar (id) {
//        log("dialog",'success')
//    }


    $(".aprobarAnulacion").button({icons : { primary : "ui-icon-check"}, text : false});
    $(".negar").button({icons : { primary : "ui-icon-close"}, text : false}).click(function () {
        var id = $(this).attr("iden")
        if (confirm("Está seguro?")) {
            $.ajax({
                type    : "POST", url : "${createLink(action:'negar', controller: 'firma' )}",
                data    : "id=" + id,
                success : function (msg) {
                    if (msg != "no") {
                        location.reload(true)
                    } else {
                        $.box({
                            title  : "Error",
                            text   : "Ha ocurrido un error interno",
                            dialog : {
                                resizable : false,
                                width     : 400,
                                buttons   : {
                                    "Cerrar" : function () {

                                    }
                                }
                            }
                        });
                    }

                }
            });
        }
    });
    $("#firmarDlg").dialog({
        autoOpen  : false,
        resizable : false,
        title     : 'Autorización Electrónica',
        modal     : true,
        draggable : true,
        width     : 500,
        height    : 200,
        position  : 'center',
        open      : function (event, ui) {
            $(".ui-dialog-titlebar-close").hide();
        },
        buttons   : {
            "Cancelar"  : function () {
                $("#firmarDlg").dialog("close")
            }, "Firmar" : function () {
                $.ajax({
                    type    : "POST", url : "${createLink(action:'firmar', controller: 'firma' )}",
                    data    : "id=" + id + "&pass=" + $("#atrz").val(),
                    success : function (msg) {
                        if (msg != "no") {
                            $("#firmarDlg").dialog("close")
                            $.box({
                                title  : "Firma",
                                text   : "Documento firmado",
                                dialog : {
                                    resizable : false,
                                    width     : 400,
                                    buttons   : {
                                        "Cerrar" : function () {
                                            location.reload(true)
                                        }
                                    }
                                }
                            });
                            location.href = msg
                        } else {

                            $.box({
                                title  : "Error",
                                text   : "Contraseña incorrecta",
                                dialog : {
                                    resizable : false,
                                    width     : 400,
                                    buttons   : {
                                        "Cerrar" : function () {

                                        }
                                    }
                                }
                            });

                        }

                    }
                });
            }
        }
    });
    $("#negar").dialog({
        autoOpen  : false,
        resizable : false,
        title     : 'Negar solicitud',
        modal     : true,
        draggable : true,
        width     : 400,
        height    : 150,
        position  : 'center',
        open      : function (event, ui) {
            $(".ui-dialog-titlebar-close").hide();
        },
        buttons   : {
            "Cancelar" : function () {
                $("#negar").dialog("close")
            }, "Negar" : function () {
                $.ajax({
                    type    : "POST", url : "${createLink(action:'negarAval', controller: 'revisionAval')}",
                    data    : "id=" + $("#avalId").val(),
                    success : function (msg) {
                        if (msg != "no")
                            location.reload(true)
                        else
                            location.href = "${createLink(controller:'certificacion',action:'listaSolicitudes')}/?msn=Usted no tiene los permisos para negar esta solicitud"

                    }
                });
            }
        }
    });


</script>
</body>
</html>