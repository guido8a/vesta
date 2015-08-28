<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/15/11
  Time: 12:04 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Reportes Varios</title>
    </head>

    <body>

        <table style="width: 960px;">
            <tr>
                <td colspan="3" style="text-align: center; font-size: 16px;">Techos presupuestarios por Área de gestión</td>
            </tr>
            <tr>
                <td>
                    <g:link class="boton" controller="reportes" action="reasignacion" target="_blank">Reasignación de techos</g:link>
                    <g:link class="boton" controller="reportes" action="reasignacionXls">Excel</g:link>
                </td>
                <td>
                    <g:link class="boton" controller="reportes" action="reasignacionDetallado" target="_blank">Reasignación de techos detallado</g:link>
                    <g:link class="boton" controller="reportes" action="reasignacionDetalladoXls">Excel</g:link>
                </td>

                <td>
                    <g:link class="boton" controller="reportes" action="reasignacionAgrupado" target="_blank">Consolidado techos de inversión y permanente</g:link>
                    <g:link class="boton" controller="reportes" action="reasignacionAgrupadoXls">Excel</g:link>
                </td>
            </tr>
            <tr>
                <td>
                    <g:link class="boton" controller="reportes2" action="totales" target="_blank">Total asignaciones</g:link>
                    <g:link class="boton" controller="pdf" action="pdfLink" params="[url:g.createLink(action: 'totales',controller: 'reportes2'),filename:'totales.pdf']">PDF</g:link>
                </td>
                <td colspan="3">&nbsp</td>
            </tr>
            <tr>
                <td colspan="4">&nbsp</td>
            </tr>
            <tr>
                <td colspan="3" style="text-align: center; font-size: 16px;">Certificaciones Emitidas</td>
            </tr>
            <tr>
                <td>
                    <g:link class="boton" controller="reportes" action="reporteCertificaciones" target="_blank">Compendio de Certificaciones</g:link>
                    <g:link class="boton" controller="pdf" action="pdfLink" params="[url:g.createLink(action: 'reporteCertificaciones'),filename:'Certificaciones.pdf']">PDF</g:link>
                </td>
            </tr>




        </table>

        <script type="text/javascript">
            $(".boton").button().css("margin", "3px");
        </script>
    </body>

</html>