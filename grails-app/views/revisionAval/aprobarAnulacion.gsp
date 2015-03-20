<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 20/03/15
  Time: 12:34 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Aprobar anulación de aval</title>
    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="revisionAval" action="pendientes" class="btn btn-default">
                    <i class="fa fa-chevron-left"></i> Regresar
                </g:link>
            </div>
        </div>

        <fieldset>
            <legend>Solicitud de anulación a aprobar</legend>

            <table class="table table-condensed table-bordered">
                <thead>
                    <tr>
                        <th>Proceso</th>
                        <th>Tipo</th>
                        <th>Concepto</th>
                        <th>Monto</th>
                        <th>Estado</th>
                        <th>Doc. Respaldo</th>
                        %{--<th>Solicitud</th>--}%
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>${solicitud.proceso.nombre}</td>
                        <td class="E03">Anulación</td>
                        <td>${solicitud.concepto}</td>
                        <td style="text-align: right">${solicitud.monto}</td>
                        <td style="">${solicitud.estado?.descripcion}</td>
                        <td style="text-align: center">
                            <g:if test="${solicitud.path}">
                                <a href="#" class="btn btn-default btn-sm descRespaldo" iden="${solicitud.id}">
                                    <i class="fa fa-search"></i>
                                </a>
                            </g:if>
                        </td>
                    </tr>
                </tbody>
            </table>
        </fieldset>

        <fieldset>
            <legend>Anular</legend>
        %{--<h3>Descargue el formulario, firmelo y subalo</h3>--}%
            <g:form action="guardarAnulacion" class="frmAprobar form-horizontal" enctype="multipart/form-data">
                <input type="hidden" name="id" value="${solicitud.id}">

                <div class="form-group">
                    <label for="archivo" class="col-sm-2 control-label">
                        Documento de respaldo
                    </label>

                    <div class="col-sm-3">
                        <input type="file" id="archivo" name="archivo" class="form-control">
                    </div>
                </div>

            %{--Ingrese el número del aval y descargue el formulario con un clic  </br>--}%
            %{--Después de llenar y firmar el documento del Aval súbalo al sistema. </br> </br>--}%
                <div class="fila">
                    <div class="labelSvt">
                        <a href="#" class="btn btn-success" id="aprobar">
                            Anular aval
                        </a>
                    </div>
                </div>

            </g:form>
        </fieldset>

        <script type="text/javascript">
            $(function () {
                $(".descRespaldo").click(function () {
                    location.href = "${createLink(controller:'avales',action:'descargaSolicitud')}/" + $(this).attr("iden");
                });

                $("#aprobar").click(function () {
                    var file = $("#archivo").val()
                    var msg = ""
                    if (file.length < 1) {
                        msg += "<br>Por favor seleccione un archivo."
                    } else {
                        var ext = file.split('.').pop();
                        if (ext != "pdf") {
                            msg += "<br>Por favor seleccione un archivo de formato pdf. El formato " + ext + " no es aceptado por el sistema"
                        }
                    }
                    if (msg == "") {
                        $(".frmAprobar").submit()
                    } else {
                        bootbox.alert(msg);
                    }
                });

            });
        </script>

    </body>
</html>