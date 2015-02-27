<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 06/02/15
  Time: 12:33 PM
--%>

<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 03/10/14
  Time: 12:19 PM
--%>

<%@ page import="vesta.contratacion.Solicitud" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Reunión de aprobación</title>

    <style type="text/css">
    textarea {
        width : 910px;
    }

    label {
        width : auto;
    }

    .wide {
        height       : 29px;
        padding-left : 5px;
    }

    .short {
        width : 85px;
    }

    .solicitud {
        border        : solid 2px #555;
        margin-bottom : 15px;
    }

    .solicitudHeader {
        padding : 5px;
        cursor  : pointer;
    }

    .info {
        font-size     : larger;
        padding       : 10px;
        background    : #d9edf7;
        margin-bottom : 15px;
        color         : #31708f;
        border        : solid 1px #bce8f1;
    }

    .important {
        font-size   : larger;
        font-weight : bold;
    }
    </style>
</head>

<body>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<g:set var="puedeEditar" value="${perfil.codigo == 'GP'}"/>
<g:if test="${params.show.toString() == '1'}">
    <g:set var="puedeEditar" value="${false}"/>
</g:if>
<g:set var="solicitudes" value="${Solicitud.findAllByAprobacion(reunion, [sort: 'fecha'])}"/>
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:link class="button create btn btn-default" action="list"><i class="fa fa-bars"></i>
            Lista de reuniones de aprobación
        </g:link>
        <g:link class="button list btn btn-default" controller="solicitud" action="list"><i class="fa fa-bars"></i>
            Lista de solicitudes
        </g:link>
        <g:if test="${puedeEditar}">
           <a href="#" id="btnSave" class="button btn btn-success"><i class="fa fa-floppy-o"></i> Guardar</a>
           <a href="#" id="btnAprobar" class="button btn btn-info"><i class="fa fa-check-square"></i> Aprobar</a>
        </g:if>

        <g:if test="${params.show.toString() == '1'}">
            <g:if test="${reunion.aprobada == 'A'}">
                <a href="#" class="button upload btn btn-default" id="uploadActa" style="float: right;"><i class="fa fa-folder-open"></i>
                    Archivar acta
                </a>
                <a href="#" id="btnPrint" class="button btn btn-default" style="float: right;"><i class="fa fa-print"></i> Imprimir</a>
            </g:if>
            <g:else>
                <g:link class="button btn btn-default" action="reunion" id="${reunion.id}" style="float: right;"><i class="fa fa-pencil"></i>
                    Editar
                </g:link>
            </g:else>
        </g:if>
    </div>
</div> <!-- toolbar -->

<div class="info ui-corner-all">
    Reunión de Planificación de contrataciones
    <g:if test="${reunion.fecha}">
        planificada para el <strong>${reunion.fecha.format("dd-MM-yyyy HH:mm")}</strong>
    </g:if>
</div>

<g:form action="saveAprobacion" name="frmAprobacion" id="${reunion.id}">
    <g:hiddenField name="aprobada" value=""/>
    <g:each in="${solicitudes}" var="solicitud" status="i">
        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true"  >
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingOne">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne${i}" aria-expanded="false" aria-controls="collapseOne${i}">
                            <i class="fa fa-archive"></i>  Solicitud ${i + 1} de ${solicitudes.size()}: ${solicitud.objetoContrato}
                        </a>
                    </h4>
                </div>
                <div id="collapseOne${i}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                    <div class="panel-body">
                        <slc:showSolicitud solicitud="${solicitud}" perfil="${perfil}" aprobacion="${puedeEditar}" multiple="true"/>
                    </div>
                </div>
            </div>
        </div>
    </g:each>

    <table class="table table-condensed table-bordered table-striped table-hover">
        <thead></thead>
        <tbody>
        <tr>
            <td colspan="2">
                <label><i class="fa fa-eye"></i> Observaciones</label>
            </td>
            <td colspan="6">
                <g:if test="${puedeEditar}">
                    <g:textArea class="ui-widget-content ui-corner-all " name="observaciones" rows="5" cols="5" value="${reunion.observaciones}" style="resize: none"/>
                </g:if>
                <g:else>
                    ${reunion.observaciones ?: '-Sin observaciones-'}
                </g:else>
            </td>
        </tr>
        <g:if test="${reunion.pathPdf}">
            <tr>
                <td colspan="2">
                <label><i class="fa fa-folder-open-o"></i> Archivo</label>
                </td>
                <td>
                    <g:link controller="solicitud" action="downloadActa" id="${reunion.id}">
                        ${reunion.pathPdf}
                    </g:link>
                </td>
            </tr>
        </g:if>
        </tbody>
    </table>
</g:form>

<div id="dialogFirmas" title="Seleccione las firmas para el acta" class="ui-helper-hidden">
    <g:set var="editable" value="${false}"/>

    <g:if test="${!reunion.firmaDireccionPlanificacion && !reunion.firmaGerenciaPlanificacion && !reunion.firmaGerenciaTecnica}">
        <g:set var="editable" value="${true}"/>
        <p>
            Recuerde que una vez generada el acta no podrá cambiar las firmas.
        </p>
    </g:if>
    <p>
        Firmas para el acta:
    </p>

    <table border="0">
        <tr>
            <th>Gerencia de Planificación</th>
            <td>
                <g:if test="${editable}">
                    <g:select from="${firmaGerenciaPlanif}" optionKey="id" optionValue="${{
                        it.nombre + ' ' + it.apellido
                    }}" name="firmaGP"/>
                </g:if>
                <g:else>
                    ${reunion.firmaGerenciaPlanificacion?.nombre} ${reunion.firmaGerenciaPlanificacion?.apellido}
                </g:else>
            </td>
        </tr>
        <tr>
            <th>Dirección de Planificación</th>
            <td>
                <g:if test="${editable}">
                    <g:select from="${firmaDireccionPlanif}" optionKey="id" optionValue="${{
                        it.nombre + ' ' + it.apellido
                    }}" name="firmaDP"/>
                </g:if>
                <g:else>
                    ${reunion.firmaDireccionPlanificacion?.nombre} ${reunion.firmaDireccionPlanificacion?.apellido}
                </g:else>
            </td>
        </tr>
        <tr>
            <th>Gerencia Técnica</th>
            <td>
                <g:if test="${editable}">
                    <g:select from="${firmaGerenciaTec}" optionKey="id" optionValue="${{
                        it.nombre + ' ' + it.apellido
                    }}" name="firmaGT"/>
                </g:if>
                <g:else>
                    ${reunion.firmaGerenciaTecnica?.nombre} ${reunion.firmaGerenciaTecnica?.apellido}
                </g:else>
            </td>
        </tr>

    </table>
</div>

%{--<div id="dialogUpload" title="Seleccione un archivo" class="ui-helper-hidden">--}%
    %{--<p>--}%
        %{--<g:uploadForm id="${reunion.id}" name="frmPdf" controller="solicitud" action="uploadActa">--}%
            %{--<input type="file" name="pdf" class="required"/>--}%
            %{--<g:if test="${reunion.pathPdf}">--}%
                %{--<br/>Archivo cargado: ${reunion.pathPdf}--}%
            %{--</g:if>--}%
        %{--</g:uploadForm>--}%
    %{--</p>--}%
%{--</div>--}%

<script type="text/javascript">

    function validacion() {
        if ($("#frmAprobacion").valid()) {
            return true;
        } else {
            $(".solicitudHeader").each(function () {
                var $body = $(this).siblings(".solicitudBody");
                if ($body.hasClass("escondido")) {
                    $body.show();
                    $body.removeClass("escondido");

                    setTimeout(function () {
                        var $target = $(".error")[0];
                        $('#divDlgBody').scrollTo($target);
                    }, 200);
                }
            });
            return false;
        }
    }

    function doSave(aprobada) {
        $("#aprobada").val(aprobada);
        $("#frmAprobacion").submit();
    }

    $(function () {

        $("#frmAprobacion").validate({

        });

        $("#dialogUpload").dialog({
            autoOpen  : false,
            modal     : true,
            resizable : false,
            buttons   : {
                "Cancelar"      : function () {
                    $(this).dialog("close");
                },
                "Subir archivo" : function () {
                    $("#frmPdf").submit();
                    $(this).dialog("close");
                }
            }
        });

        $("#dialogFirmas").dialog({
            autoOpen  : false,
            modal     : true,
            resizable : false,
            width     : 400,
            buttons   : {
                "Cancelar" : function () {
                    $(this).dialog("close");
                },
                "Imprimir" : function () {
                    var url = "${createLink(controller: 'reporteSolicitud', action: 'imprimirActaReunionAprobacion')}/?id=${reunion.id}";
                    var firmaGP = $("#firmaGP").val();
                    var firmaDP = $("#firmaDP").val();
                    var firmaGT = $("#firmaGT").val();
                    var firmaRQ = $("#firmaRQ").val();
                    url += "Wfgp=" + firmaGP + "Wfdp=" + firmaDP + "Wfgt=" + firmaGT + "Wfrq=" + firmaRQ;
//                            console.log(url);
                    location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=acta_aprobacion.pdf";
                }
            }
        });

        $("#btnPrint").button("option", "icons", {primary : 'ui-icon-print'}).click(function () {
            $("#dialogFirmas").dialog("open");
            return false;
        });

        $(".solicitudBody").each(function () {
            var $body = $(this);
            $body.hide();
            $body.addClass("escondido");
        });

        $(".solicitudHeader").click(function () {
            var $body = $(this).siblings(".solicitudBody");
            if ($body.hasClass("escondido")) {
                $body.show();
                $body.removeClass("escondido");
            } else {
                $body.hide();
                $body.addClass("escondido");
            }
        });

        $(".collapsed").each(function () {
            var $c = $(this);
            var $tbody = $c.parents("thead").siblings("tbody");
            $tbody.addClass("escondido");
            $tbody.hide();
        });
        $(".collapsible").click(function () {
            var $c = $(this);
            var $tbody = $c.parents("thead").siblings("tbody");
            if ($tbody.hasClass("escondido")) {
                $tbody.show();
                $tbody.removeClass("escondido");
            } else {
                $tbody.hide();    $("#dialogUpload").dialog("open");
            return false;
                $tbody.addClass("escondido");
            }

        });

        $("#frmPdf").validate({

        });

        $("#uploadActa").click(function () {
//            $("#dialogUpload").dialog("open");
            $.ajax ({
              type : "POST",
              url  : "${createLink(action: 'subirActa_ajax', id: reunion.id)}",
              success : function (msg){
                  bootbox.dialog({
                      id: "dlgSubirActa",
                      title: "Subir Acta",
//                      class: "modal-lg",
                      message: msg,
                      buttons : {
                          cancelar : {
                              label: "Cancelar",
                              className: "btn-primary",
                              callback: function () {
                              }
                          },
                          aprobar : {
                              id : "btnAprobar",
                              label : "<i class='fa fa-arrow-up'></i> Subir",
                              className : "btn-success",
                              callback : function () {
                                submitForm()

                              }
                          }
                      }
                  });
              }
            });
            return false;
        });


        function submitForm() {
            var $form = $("#frmPdf");
                openLoader("Guardando Acta");
                var formData = new FormData($form[0]);
                $.ajax({
                    type        : "POST",
                    url         : $form.attr("action"),
                    data        : formData,
                    async       : false,
                    cache       : false,
                    contentType : false,
                    processData : false,
                    success     : function (msg) {
                        var parts = msg.split("*");
                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                        setTimeout(function () {
                            if (parts[0] == "SUCCESS") {
                                location.reload(true);
                            } else {
                                return false;
                            }
                        }, 1000);
                    }
                });
        }

//        $(".tipoAprobacion").selectmenu({width : 210});

        $(".button").button();

        $("#btnSave").click(function () {
            if (validacion()) {
                doSave("");
            }
        });
        $("#btnAprobar").click(function () {
            if (validacion()) {
                bootbox.dialog({
                    id: "dlgAprobar",
                    title: "Alerta",
                    class: "modal-lg",
                    message: "Una vez aprobada la reunión de planificación de contrataciones " +
                    "<span class='important'>se le asignará un número</span> y " +
                    "<span class='important'>ya no podrá modificar sus datos</span>.<br/><br/>" +
                    "<span class='important'>¿Desea continuar?</span>",
                    buttons: {
                        cancelar : {
                            label : "Cancelar",
                            className: "btn-primary",
                            callback : function () {
                            }
                        },
                        aprobar : {
                            id : "btnAprobar",
                            label : "<i class='fa fa-check-o'></i> Aceptar",
                            className : "btn-success",
                            callback : function () {
                                doSave("A")
                            }
                        }
                    }

                });
            }
        });
        $("#btnPrint").button("option", "icons", {primary : 'ui-icon-print'}).click(function () {
            $("#dialogFirmas").dialog("open");
            return false;
        });
        $(".list").button("option", "icons", {primary : 'ui-icon-clipboard'});
        $(".create").button("option", "icons", {primary : 'ui-icon-document'});
        $(".revision").button("option", "icons", {primary : 'ui-icon-check'});

    });

</script>
</body>
</html>