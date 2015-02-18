<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Solicitudes pendientes</title>
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

    <style type="text/css">

    th{
        background-color: #363636;

    }


    </style>

</head>
<body>
<g:if test="${flash.message}">
    <div class="message ui-state-highlight ui-corner-all">
        ${flash.message}
    </div>
</g:if>
<div id="tabs" style="width: 1050px;margin-top: 10px;">
    <ul>
        <li><a href="#solicitudes">Solicitudes pendientes</a></li>
        <li><a href="#historial">Historial</a></li>
        %{--<li><a href="#solicitudes">Historial</a></li>--}%
    </ul>
    <div id="solicitudes" style="width: 1030px;">
        <g:if test="${solicitudes.size()>0}">
            <table style="width: 100%;margin-top: 10px;font-size: 10px;" >
                <thead>
                <tr>
                    <th># Sol.</th>
                    <th>Fecha</th>
                    <th>Unidad</th>
                    <th>Proyecto</th>
                    <th>Concepto</th>
                    <th>Estado</th>
                    <th>Solicitud</th>
                    <th>Matriz</th>
                    <th>Acción</th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${solicitudes}" var="p">
                    <tr>
                        <td>${p.id}</td>
                        <td>${p.fecha.format("dd-MM-yyyy")}</td>
                        <td>${p.usuario.unidad}</td>
                        <td>${p.origen.marcoLogico.proyecto}</td>
                        <td>${p.concepto}</td>
                        %{--<td style="text-align: right"> <g:formatNumber number="${p.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber></td>--}%
                        <td style="text-align: center" class="E0${p.estado}">
                            <g:if test="${p.estado==0}">
                                Solicitado
                            </g:if>
                            <g:if test="${p.estado==1}">
                                Aprobado
                            </g:if>
                            <g:if test="${p.estado==2}">
                                Negado
                            </g:if>
                        </td>
                        <td style="text-align: center">
                            <a href="#" class="btn imprimiSolicitud" iden="${p.id}">Ver</a>
                        </td>
                        <td style="text-align: center">
                            <a href="#" class="btn matriz" iden="${p.id}">Ver</a>
                        </td>
                        <td style="text-align: center">
                            <a href="${g.createLink(controller: 'modificacionesPoa',action: 'verSolicitud',id:p.id)}" class="btn " iden="${p.id}" title="Aprobar o Negar">Procesar</a>

                        </td>

                    </tr>
                </g:each>

                </tbody>
            </table>
        </g:if>
    </div>
    <div id="historial" style="width: 1030px;">
        <table style="width: 1000px;margin-top: 10px;font-size: 10px;" >
            <thead>
            <tr>
                <th># Sol.</th>
                <th>Unidad</th>
                <th>Proyecto</th>
                <th>Concepto</th>
                <th>Estado</th>
                <th>Solicitud</th>
                <th>Matriz</th>
                <th>Reforma</th>
                <th>Ver</th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${historial}" var="p">
                <tr>
                    <td>${p.id}</td>
                    <td>${p.usuario.unidad}</td>
                    <td>${p.origen.marcoLogico.proyecto}</td>
                    <td>${p.concepto}</td>
                    %{--<td style="text-align: right"> <g:formatNumber number="${p.monto}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber></td>--}%
                    <td style="text-align: center" class="${(p.estado==0)?'solicitado':(p.estado==1 || p.estado==3)?'aprobado':'negado'}">
                        <g:if test="${p.estado==0}">
                            Solicitado
                        </g:if>
                        <g:if test="${p.estado==1 || p.estado==3}">
                            Aprobado
                        </g:if>
                        <g:if test="${p.estado==2}">
                            Negado
                        </g:if>
                        <g:if test="${p.estado==5}">
                            Aprobado sin firmas
                        </g:if>
                    </td>
                    <td style="text-align: center">
                        <a href="#" class="btn imprimiSolicitud" iden="${p.id}">Ver</a>
                    </td>
                    <td style="text-align: center">
                        <a href="#" class="btn matriz" iden="${p.id}">Ver</a>
                    </td>
                    <td style="text-align: center">
                        <g:if test="${p.estado==3 || p.estado==5}">
                            <a href="#" class="btn reforma" iden="${p.id}">Ver</a>
                        </g:if>
                    </td>
                    <td style="text-align: center">
                        <a href="${g.createLink(controller: 'modificacionesPoa',action: 'verSolicitud',id:p.id)}" class="btn " iden="${p.id}">Ver</a>

                    </td>

                </tr>
            </g:each>

            </tbody>
        </table>
    </div>

</div>
<div id="negar">
    <input type="hidden" id="avalId">
    Esta seguro que desea negar esta solicitud de certificación?
</div>
<script>
    function cargarHistorial(anio,numero,proceso){


        %{--$.ajax({--}%
        %{--type:"POST", url:"${createLink(action:'historial', controller: 'revisionAval')}",--}%
        %{--data:{--}%
        %{--anio:anio,--}%
        %{--numero:numero,--}%
        %{--proceso:proceso--}%
        %{--},--}%
        %{--success:function (msg) {--}%
        %{--$("#detalle").html(msg)--}%

        %{--}--}%
        %{--});--}%

    }
    $(".btn").button()
    %{--$("#buscar").button().click(function(){--}%
    %{--cargarHistorial($("#anio").val(),$("#numero").val(),$("#descProceso").val())--}%
    %{--})--}%
    %{--$(".descRespaldo").click(function(){--}%
    %{--location.href = "${createLink(controller:'avales',action:'descargaSolicitud')}/"+$(this).attr("iden")--}%

    %{--});--}%
    $(".reforma").button({icons:{ primary:"ui-icon-print"},text:false}).click(function(){
        var url = "${g.createLink(controller: 'reporteReformaPoa',action: 'reformaPoa')}/?id="+$(this).attr("iden")
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url+"&filename=matriz.pdf"
    })
    $(".matriz").button({icons:{ primary:"ui-icon-print"},text:false}).click(function(){
        var url = "${g.createLink(controller: 'reporteReformaPoa',action: 'solicitudReformaPoa')}/?id="+$(this).attr("iden")
//        location.href = url
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url+"&filename=matriz.pdf"
    })
    $(".imprimiSolicitud").button({icons:{ primary:"ui-icon-print"},text:false}).click(function(){
        var url = "${g.createLink(controller: 'reporteSolicitud',action: 'solicitudReformaPdf')}/?id="+$(this).attr("iden")
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url+"&filename=Solicitud.pdf"
    })
    $("#tabs").tabs()
    $(".aprobar").button({icons:{ primary:"ui-icon-check"},text:false});
    $(".aprobarAnulacion").button({icons:{ primary:"ui-icon-check"},text:false});
    $(".negar").button({icons:{ primary:"ui-icon-close"},text:false}).click(function(){
        $("#avalId").val($(this).attr("iden"))
        $("#negar").dialog("open")
    });
    $("#negar").dialog({
        autoOpen:false,
        resizable:false,
        title:'Negar solicitud',
        modal:true,
        draggable:true,
        width:400,
        height:150,
        position:'center',
        open:function (event, ui) {
            $(".ui-dialog-titlebar-close").hide();
        },
        buttons:{
            "Cancelar":function () {
                $("#negar").dialog("close")
            },"Negar":function(){
                $.ajax({
                    type:"POST", url:"${createLink(action:'negar', controller: 'modificacionesPoa')}",
                    data:"id=" + $("#avalId").val(),
                    success:function (msg) {
                        if(msg!="no")
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