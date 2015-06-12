<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Avances financieros</title>
    <link rel="stylesheet" href="${resource(dir: 'css/custom', file: 'semaforos.css')}" type="text/css"/>
</head>

<body>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>


<div class="row no-margin-top">
    <div class="col-md-4">
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="avales" action="listaProcesos" class="btn btn-default btn-sm"><i class="fa fa-bars"></i> Lista de procesos</g:link>
                %{--<g:link controller="hito" action="cargarExcelHitos" class="btn btn-default btn-sm"><i class="fa fa-check"></i> Registrar avances financieros</g:link>--}%
                <a href="#" class="btn btn-success btn-sm btnCargar"><i class="fa fa-check"></i> Registrar avances financieros</a>
            </div>
        </div>
    </div>
</div>


<fieldset>
    <legend>Proceso</legend>
    <div class="row">
        <div class="col-md-7 alert alert-info sh" style="height: 100%;">
            <div class="row no-margin-top">
                <label class="col-md-3 control-label">
                    Proyecto
                </label>

                <div class="col-md-6">
                    ${proceso?.proyecto.toStringCompleto()}
                </div>
            </div>

            <div class="row no-margin-top">
                <label class="col-md-3 control-label">
                    Fecha inicio</label>

                <div class="col-md-2">
                    ${proceso.fechaInicio.format("dd-MM-yyyy")}
                </div>
                <label class="col-md-2 control-label">Fecha fin</label>

                <div class="col-md-2">
                    ${proceso.fechaFin.format("dd-MM-yyyy")}
                </div>
            </div>

            <div class="row no-margin-top">
                <label class="col-md-3 control-label">Nombre</label>

                <div class="col-md-6">
                    ${proceso.nombre}
                </div>
            </div>

            <div class="row no-margin-top">
                <label class="col-md-3 control-label">Reportar cada</label>

                <div class="col-md-4">
                    ${proceso.informar} Días
                </div>
            </div>
        </div>

        <div class="col-md-5 alert alert-success sh" style="height: 100%;">
            <g:if test="${aval}">
                <g:set var="dataProceso" value="${aval.getColorSemaforo()}"/>

                <div class="row no-margin-top">
                    <label class="col-md-6 control-label">
                        Avance real al ${new java.util.Date().format("dd/MM/yyyy")}:
                    </label>

                    <div class="col-md-4">
                        ${dataProceso[1]}% (a)
                    </div>
                </div>

                <div class="row no-margin-top">
                    <label class="col-md-6 control-label">
                        Avance esperado:
                    </label>

                    <div class="col-md-4">
                        ${dataProceso[0].toDouble().round(2)}% (b)
                    </div>
                </div>

                <div class="semaforo ${dataProceso[2]}" title="Avance esperado al ${new Date().format('dd/MM/yyyy')}: ${dataProceso[0].toDouble().round(2)}$, avance registrado: ${dataProceso[1].toDouble().round(2)}$">
                </div>

                <div class="row no-margin-top" style="margin-top: 5px">
                    <label class="col-md-6 control-label">
                        Último Avance:
                    </label>

                    <div class="col-md-6">
                        ${dataProceso[3]}
                    </div>
                </div>
            </g:if>
        </div>
    </div>

</fieldset>
<g:if test="${aval}">
    <fieldset>
        <legend>Aval</legend>
        <div class="row">
            <div class="col-md-12 alert alert-info sh" style="height: 100%;">
                <div class="fila">
                    <div class="row no-margin-top">
                        <label class="col-md-2 control-label">
                            Número
                        </label>
                        <div class="col-md-2">
                            ${aval.fechaAprobacion?.format("yyyy")}-GP No.<elm:imprimeNumero aval="${aval.id}"/>
                        </div>
                    </div>
                    <div class="row no-margin-top">
                        <label class="col-md-2 control-label">
                            Emisión
                        </label>
                        <div class="col-md-2">
                            ${aval.fechaAprobacion?.format("dd-MM-yyyy")}
                        </div>
                    </div>
                    <div class="row no-margin-top">
                        <label class="col-md-2 control-label">
                            Estado
                        </label>
                        <div class="col-md-2">
                            ${aval.estado.descripcion}
                        </div>
                    </div>
                </div>

                <div class="fila">
                    <div class="row no-margin-top">
                        <label class="col-md-2 control-label">
                            Monto
                        </label>
                        <div class="col-md-2">
                            <g:formatNumber number="${aval.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" />$
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </fieldset>
</g:if>
<fieldset style="width: 100%;height: 350px;overflow: auto" class="ui-corner-all">
    <legend>Avances financieros</legend>

    <div id="detalle" style="width: 100%; height: 260px; overflow: auto;">
        <g:if test="${avances.size()>0}">
        <table class="table table-condensed table-bordered table-striped table-hover">
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
                        $<g:formatNumber number="${avances?.pop()?.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                    </td>
                </tr>
                </tbody>
            </table>
        </g:if>
    </div>
</fieldset>



<script type="text/javascript">

    $(function () {
        var mh = 0;
        $(".sh").each(function () {
            var h = $(this).height();
            if (mh < h) {
                mh = h;
            }
        }).each(function () {
            $(this).height(mh);
        });

//        loadTabla();


        $(".btnCargar").click(function () {
            var data = ''
            $.ajax({
               type: "POST",
                url: "${createLink(action: 'cargarExcel_ajax')}",
                data: data,
                success : function (msg){
                    var b = bootbox.dialog({
                        id    : "dlgCargar",
                        title : "Cargar avances financieros",

//                        class : "modal-lg",

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
                                label     : "<i class='fa fa-arrow-up'></i> Subir",
                                className : "btn-success",
                                callback  : function () {
//                                    return submitForm();
                                    $("#frmUpload").submit();
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                }


            });

        });

    });

</script>

</body>
</html>