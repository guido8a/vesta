<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 01/04/15
  Time: 03:09 PM
--%>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Modificaciones al POA del proyecto ${proyecto.nombre}</title>
</head>

<body>

<div style="margin-left: 10px;">

    <div style="margin-top: 15px;">
        <b>Año:</b>
        <g:select from="${vesta.parametros.poaPac.Anio.list([sort:'anio'])}" id="anio_asg" name="anio" optionKey="id" optionValue="anio" value="${actual.id}"/>

        %{--<g:link class="btn" controller="entidad" action="arbol_asg">Unidades ejecutoras</g:link>--}%
        <g:link class="btn btn-default btn-sm" controller="modificacion" action="poaInversionesMod" id="${proyecto?.id}"><i class="fa fa-arrow-left"></i> Modificaciones POA</g:link>

        %{--<g:link class="btn"  controller="pdf" action="pdfLink" params="[url:g.createLink(controller:'reportes',action:'modificacionesPoa',id:unidad.id),filename:'Modificaciones_poa_'+unidad.id+'.pdf']" >Reporte</g:link>--}%


        %{--<a href="#" class="btn btn-default btnRegresar">--}%
        %{--<i class="fa fa-arrow-left"></i> Modificaciones POA--}%
        %{--</a>--}%

    </div>
    <g:each in="${res}" var="mod" status="i">
        %{--<table width="1020px;" style="margin-top: 20px;font-size: 11px">--}%
                                    <table class="table table-condensed table-bordered table-striped table-hover" style="margin-top: 20px">

            <thead>
            <th ><b># ${i+1}</b></th>
            <th style="width: 250px;" >Actividad</th>
            <th >Partida</th>
            <th style="width: 150px" >Desc. partida</th>
            <th >Fuente</th>
            <th >Presupuesto</th>
            </thead>
            <tbody>

            <tr>
                <td>
                    <b>Desde:</b>
                </td>
                <td class="actividad" title="${(mod.desde.marcoLogico)?mod.desde.marcoLogico.toStringCompleto():mod.desde.actividad}">
                    ${(mod.desde.marcoLogico)?mod.desde.marcoLogico:mod.desde.actividad}
                                </td>

                <td class="prsp" style="text-align: center">
                    ${mod.desde.presupuesto.numero}
                </td>

                <td class="desc">
                    ${mod.desde.presupuesto?.descripcion}
                </td>

                <td class="fuente">
                    ${mod.desde.fuente?.descripcion}
                </td>

                <td class="valor" style="text-align: right">
                    <g:formatNumber number="${(mod.desde.redistribucion==0)?mod.desde.priorizado.toFloat():mod.desde.redistribucion.toFloat()}"
                                    format="###,##0"
                                    minFractionDigits="2" maxFractionDigits="2"/>

                </td>
            </tr>
            <tr>
                <td>
                    <b> Hasta: </b>
                </td>
                <td class="actividad" title=" ${(mod.recibe.marcoLogico)?mod.recibe.marcoLogico.toStringCompleto():mod.recibe.actividad}">
                    ${(mod.recibe.marcoLogico)?mod.recibe.marcoLogico:mod.recibe.actividad}
                </td>

                <td class="prsp" style="text-align: center">
                    ${mod.recibe.presupuesto.numero}
                </td>

                <td class="desc">
                    ${mod.recibe.presupuesto?.descripcion}
                </td>

                <td class="fuente">
                    ${mod.recibe.fuente?.descripcion}
                </td>

                <td class="valor" style="text-align: right">
                    <g:formatNumber number="${mod.recibe.priorizado}"
                                    format="###,##0"
                                    minFractionDigits="2" maxFractionDigits="2"/>
                </td>
            </tr>
            <tr>
                <td>
                    <b>Valor:</b>
                </td>
                <td>
                    <g:formatNumber number="${mod.valor}"
                                    format="###,##0"
                                    minFractionDigits="2" maxFractionDigits="2"/>
                </td>
            </tr>
            <tr>
                <td>
                    <b> Fecha:</b>
                </td>
                <td>
                    ${mod.fecha?.format("dd/MM/yyyy")}
                </td>
            </tr>
            </tbody>
        </table>

    </g:each>

</div>

<div id="load">
    <img src="${g.resource(dir:'images',file: 'loading.gif')}" alt="Procesando">
    Procesando
</div>
<script type="text/javascript">
    %{--$("#anio_asg, #programa").change(function () {--}%
        %{--location.href = "${createLink(controller:'modificacion',action:'verModificacionesPoa')}?id=${unidad.id}&anio=" + $("#anio_asg").val() + "&programa=" + $("#programa").val();--}%
    %{--});--}%


    $("#anio_asg, #programa").change(function () {
        location.href = "${createLink(controller:'modificacion',action:'verModificacionesPoa')}?id=${unidad.id}&anio=" + $("#anio_asg").val() + "&proyecto=" + ${proyecto.id};
    });

    $("#load").dialog({
        width:100,
        height:100,
        position:"center",
        title:"Procesando",
        modal:true,
        autoOpen:false,
        resizable:false,
        open: function(event, ui) {
            $(event.target).parent().find(".ui-dialog-titlebar-close").remove()
        }
    });
    %{--$(".btn").button()--}%
    %{--$(".pdf").click(function(){--}%
        %{--location.href = "${createLink(controller:'modificacion',action:'descargaDocumento')}/"+$(this).attr("iden")--}%
    %{--});--}%

    %{--$(".btnRegresar").click(function () {--}%
        %{--window.history.back()--}%

    %{--});--}%

</script>


</body>
</html>