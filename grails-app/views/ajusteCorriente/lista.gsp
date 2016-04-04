<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 24/06/15
  Time: 09:56 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Lista de ajustes</title>

        <link rel="stylesheet" href="${resource(dir: 'css/custom', file: 'avales.css')}" type="text/css"/>
    </head>

    <body>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link action="ajustes" class="btn btn-default btnCrear">
                    <i class="fa fa-file-o"></i> Solicitar ajuste
                </g:link>
            </div>
        </div>

        <table class="table table-bordered table-hover table-condensed">
            <thead>
                <tr>
                    <th>Solicita</th>
                    <th style="width: 85px;">Fecha</th>
                    <th>Concepto</th>
                    <th>Tipo</th>
                    <th>Estado</th>
                    <th style="width: 125px;">Ver</th>
                </tr>
            </thead>
            <tbody>
                <g:each in="${reformas}" var="reforma">
                    <tr id="trLista" data-id="${reforma?.id}">

                        <td>${reforma.persona.unidad} - ${reforma.persona}</td>
                        <td>${reforma.fecha.format("dd-MM-yyyy")}</td>
                        <td>${reforma.concepto}</td>
                        <td>
                            <elm:tipoReforma reforma="${reforma}"/>
                        </td>
                        <td class="${reforma.estado.codigo}">${reforma.estado.descripcion}</td>
                        <td style="text-align: center">
                            <div class="btn-group btn-group-sm" role="group">
                                <elm:linkPdfReforma reforma="${reforma}"/>
                                <g:if test="${session.perfil.codigo != 'OBS'}">
                                    <g:if test="${reforma?.estado?.codigo == 'P01' && (unidad == 'DF' || unidad == 'DA' || unidad == 'GAF')}">
                                    <a href="#" id="btnEditar" class="btn btn-success edit" data-ref="${reforma?.id}" title="Editar"><i class="fa fa-pencil"></i></a>
                                    <a href="#" id="btnBorrar" class="btn btn-danger borrar" data-ref="${reforma?.id}" title="Borrar"><i class="fa fa-trash"></i></a>
                                    </g:if>
                                </g:if>
                            </div>
                        </td>
                    </tr>
                </g:each>
            </tbody>
        </table>

        <script type="text/javascript">

            $(".edit").click(function () {
                console.log($(this).data("ref"));

                var idf = $(this).data("ref");
                location.href = "${createLink(controller: 'ajusteCorriente', action: 'existente')}?id=" + idf;


            });

            $(".borrar").click(function () {

            var r = $(this).data("ref")
                bootbox.confirm("Eliminar el ajuste?", function (result) {
                    if(result){
                        console.log(r);
                        $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'ajusteCorriente', action:'borrarAjuste_ajax')}",
                        data    : {
                        id  :  r
                        },
                        success : function (msg) {
                            if(msg == 'ok'){
                                log("Ajuste borrado correctamente", "success");
                                location.href="${createLink(controller: 'ajusteCorriente', action: 'lista')}"
                            }else{
                                log("Error al borrar ajuste","error")
                            }
                        }
                        });
                    }
                });

            });


        </script>
    </body>
</html>