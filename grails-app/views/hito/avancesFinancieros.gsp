<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Avances financieros</title>
    <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/jBreadCrumb/Styles', file: 'Base.css')}"
          type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/jBreadCrumb/Styles', file: 'BreadCrumb.css')}"
          type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'svt.css')}"
          type="text/css"/>
    <script src="${resource(dir: 'js/jquery/plugins/', file: 'jquery.easing.1.3.js')}" type="text/javascript"
            language="JavaScript"></script>
    <script src="${resource(dir: 'js/jquery/plugins/jBreadCrumb/js', file: 'jquery.jBreadCrumb.1.1.js')}"
            type="text/javascript" language="JavaScript"></script>

    <script type="text/javascript" src="${resource(dir: 'js/jquery/plugins/select', file: 'jquery.ui.selectmenu.js')}"></script>
    <link rel="stylesheet" href="${resource(dir: 'js/jquery/plugins/select', file: 'jquery.ui.selectmenu.css')}"/>

    <script type="text/javascript" src="${resource(dir: 'js/jquery/plugins', file: 'jquery.meio.mask.js')}"></script>

</head>

<body>
<g:if test="${flash.message}">
    <div class="message ui-state-highlight ui-corner-all">
        ${flash.message}
    </div>
</g:if>
<div class="fila">
    <g:link controller="avales" action="listaProcesos" class="btn">Lista de procesos</g:link>
    <g:link controller="hito" action="cargarExcelHitos" class="btn">Registrar avances financieros</g:link>
</div>
<fieldset style="width: 95%;height: 190px;" class="ui-corner-all">
    <legend>Proceso</legend>
    <div style="width: 65%;float: left;height: 95%">
        <div class="fila">
            <div class="labelSvt">Proyecto:</div>

            <div class="fieldSvt-xxl">
                ${proceso.proyecto}
            </div>
        </div>

        <div class="fila">

            <div class="labelSvt">Fecha inicio:</div>

            <div class="fieldSvt-small">
                ${proceso.fechaInicio.format("dd-MM-yyyy")}
            </div>

            <div class="labelSvt">Fecha fin:</div>

            <div class="fieldSvt-small">
                ${proceso.fechaFin.format("dd-MM-yyyy")}
            </div>
        </div>

        <div class="fila">
            <div class="labelSvt">Nombre:</div>

            <div class="fieldSvt-xxl">
                ${proceso.nombre}
            </div>
        </div>
        <div class="fila">
            <div class="labelSvt">Reportar cada:</div>

            <div class="fieldSvt-xxl">
                ${proceso.informar} Días
            </div>
        </div>
    </div>
    <div style="width: 34%;float: left;height: 95%;font-size: 11px">
        <g:if test="${aval}">
            <g:set var="dataProceso" value="${aval.getColorSemaforo()}"></g:set>

            <div class="fila">
                <b>Avance real al ${new java.util.Date().format("dd/MM/yyyy")}:</b> $<g:formatNumber number="${dataProceso[1]}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/> (a)
            </div>
            <div class="fila">
                <b>Avance esperado:</b> $<g:formatNumber number="${dataProceso[0]}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/> (b)
            </div>
            <div class="semaforo ${dataProceso[2]}" title="Avance esperado al ${new Date().format('dd/MM/yyyy')}: ${dataProceso[0].toDouble().round(2)}$, avance registrado: ${dataProceso[1].toDouble().round(2)}$">
            </div>

            <div class="fila">
                <b>Último Avance:</b> ${dataProceso[3]}
            %{--${dataProceso}--}%
            </div>
        </g:if>
    </div>


</fieldset>
<g:if test="${aval}">
    <fieldset style="width: 95%;height: 120px;" class="ui-corner-all">
        <legend>Aval</legend>
        <div style="width: 100%;float: left;height: 95%">
            <div class="fila">
                <div class="labelSvt">Número:</div>

                <div class="fieldSvt-medium">
                    ${aval.fechaAprobacion?.format("yyyy")}-GP No.<tdn:imprimeNumero aval="${aval.id}"/>
                </div>
                <div class="labelSvt">Emisión:</div>

                <div class="fieldSvt-small">
                    ${aval.fechaAprobacion?.format("dd-MM-yyyy")}
                </div>
                <div class="labelSvt">Estado:</div>

                <div class="fieldSvt-small">
                    ${aval.estado.descripcion}
                </div>
            </div>

            <div class="fila">

                <div class="labelSvt">Monto:</div>

                <div class="fieldSvt-small">
                    <g:formatNumber number="${aval.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>$
                </div>
            </div>
        </div>
    </fieldset>
</g:if>
<fieldset style="width: 95%;height: 350px;overflow: auto" class="ui-corner-all">
    <legend>Avances financieros</legend>

    %{--<div class="fila" style="margin-bottom: 10px;">--}%
    %{--<a href="#" class="btn" id="btnOpenDlg">Agregar</a>--}%
    %{--</div>--}%

    <div id="detalle" style="width: 95%; height: 260px; overflow: auto;">
        <g:if test="${avances.size()>0}">
            <table border="1" width="100%" style="font-size: 10px">
                <thead>
                <tr>
                    <th>Fecha</th>
                    <th>Contrato</th>
                    <th>Monto</th>
                    <th>Devengado</th>
                </tr>
                </thead>
                <tbody>
                <g:set var="total" value="${0}"/>
                <g:each in="${avances}" var="avance" status="i">
                    <tr>
                        <td>${avance.fecha.format("dd/MM/yyyy")}</td>
                        <td>${avance.contrato}</td>
                        <td style="text-align: right">$<g:formatNumber number="${avance.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" /></td>
                        <td style="text-align: right">$<g:formatNumber number="${avance.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                    </tr>
                </g:each>
                <tr>

                    <td colspan="3" style="text-align: right;font-weight: bold">
                        Total devengado:
                    </td>
                    <td style="font-weight: bold;text-align: right">
                        $<g:formatNumber number="${avances.pop().valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                    </td>
                </tr>
                </tbody>
            </table>
        </g:if>
    </div>
</fieldset>



<script type="text/javascript">





    $(function () {

        $(".btn").button();
        $(".datepicker").datepicker();
        $(".datepickerR").datepicker({
            minDate:new Date(${proceso.fechaInicio.format("yyyy")}, ${proceso.fechaInicio.format("MM")}-1, ${proceso.fechaInicio.format("dd")})
        });
        loadTabla();
    });
</script>

</body>
</html>