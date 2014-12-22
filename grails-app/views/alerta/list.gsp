<%@ page import="vesta.alertas.Alerta" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Lista de Alerta</title>

        <style type="text/css">
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
                            <td class="d${(((new Date()) - alertaInstance.fechaEnvio) > 2) ? "mas" : (new Date()) - alertaInstance.fechaEnvio}"></td>
                            <td><g:formatDate date="${alertaInstance.fechaEnvio}" format="dd-MM-yyyy"/></td>
                            <td><elm:textoBusqueda busca="${params.search}"><g:fieldValue bean="${alertaInstance}" field="mensaje"/></elm:textoBusqueda></td>
                            <td>${alertaInstance.from}</td>
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
                                No se econtraron registros que mostrar
                            </g:else>
                        </td>
                    </tr>
                </g:else>
            </tbody>
        </table>

        <elm:pagination total="${alertaInstanceCount}" params="${params}"/>
    </body>
</html>
