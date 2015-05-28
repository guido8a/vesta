<%@ page import="vesta.alertas.Alerta" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Lista de Alerta</title>

        <style type="text/css">
        .clickable {
            vertical-align : middle !important;
            cursor         : pointer;
        }

        .selected {
            font-weight : bold;
        }

        .d0 {
            background : #e0ffc8;
        }

        .d1 {
            background : #fff949;
        }

        .d2 {
            background : #ff9d4d;
        }

        .dmas {
            background : #ff573f;
        }
        </style>
    </head>

    <body>

        <elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

        <div class="alert tdn-note alert-warning" style="margin-top: 15px;">
            <i class="fa fa-2x fa-exclamation-triangle text-shadow" style="margin-top: 15px;"></i> Tiene ${alertaInstanceCount} alertas sin revisar
        </div>

        <p>
            <a href="#" class="btn btn-default" id="btnRead">
                <i class="fa fa-check"></i>
                Marcar como leídas las alertas marcadas
            </a>
        </p>

        <table class="table table-condensed table-bordered table-striped table-hover">
            <thead>
                <tr>
                    <th></th>
                    <th>Fecha</th>
                    <th>Mensaje</th>
                    <th>Originador</th>
                    <th>Link</th>
                </tr>
            </thead>
            <tbody>
                <g:if test="${alertaInstanceCount > 0}">
                    <g:each in="${alertaInstanceList}" status="i" var="alertaInstance">
                        <tr>
                            <td class="d${(((new Date()) - alertaInstance.fechaEnvio) > 2) ? "mas" : (new Date()) - alertaInstance.fechaEnvio} clickable" data-id="${alertaInstance.id}">
                                <i class="fa fa-square-o"></i>
                            </td>
                            <td><g:formatDate date="${alertaInstance.fechaEnvio}" format="dd-MM-yyyy"/></td>
                            <td><elm:textoBusqueda busca="${params.search}">
                                ${alertaInstance.mensaje}
                            </elm:textoBusqueda></td>
                            <td>${alertaInstance.from.unidad}</td>
                            <td class="text-center">
                                <g:link action="showAlerta" id="${alertaInstance.id}" class="btn btn-default">IR</g:link>
                            </td>
                        </tr>
                    </g:each>
                </g:if>
                <g:else>
                    <tr class="danger">
                        <td class="text-center" colspan="8">
                            <g:if test="${params.search && params.search != ''}">
                                No se encontraron resultados para su búsqueda
                            </g:if>
                            <g:else>
                                No se encontraron registros que mostrar
                            </g:else>
                        </td>
                    </tr>
                </g:else>
            </tbody>
        </table>

        <elm:pagination total="${alertaInstanceCount}" params="${params}"/>

        <script type="text/javascript">
            $(function () {
                $(".clickable").click(function () {
                    var $i = $(this).children("i");
                    if ($i.hasClass("fa-square-o")) {
                        $i.removeClass("fa-square-o").addClass("fa-check-square-o selected");
                    } else {
                        $i.removeClass("fa-check-square-o selected").addClass("fa-square-o");
                    }
                });

                $("#btnRead").click(function () {
                    var ids = "";
                    var c = 0;
                    $(".selected").each(function () {
                        ids += $(this).parent().data("id") + ";";
                        c++;
                    });
                    if (c > 0) {
                        var s = c == 1 ? "" : "s";
                        var n = c == 1 ? "" : "n";
                        bootbox.confirm("¿Está seguro de querer marcar como leída" + s + " <strong>" + c + "</strong> alerta" + s + " seleccionada" + s + "? " +
                                        "<br/>Este proceso es irreversible y ya no se mostrará" + n + " en la lista.", function () {
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink( action:'marcarLeidas_ajax')}",
                                data    : {
                                    ids : ids
                                },
                                success : function (msg) {
                                    location.reload(true);
                                }
                            });
                        });
                    }
                    return false;
                });
            });
        </script>

    </body>
</html>
