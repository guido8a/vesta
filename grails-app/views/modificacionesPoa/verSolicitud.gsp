<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Porcesar Solicitud de Reforma</title>
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
    <style type="text/css">

    th{
        background-color: #363636;
        border-color: #ffffff;

    }
    .valor{
        text-align: right;
    }
    .center{
        text-align: center;
    }

    </style>

</head>

<body>
<div class="fila">
    <g:link controller="modificacionesPoa" action="listaPendientes" class="btn">Regresar</g:link>
</div>
<div style="width: 45%;;display: inline-table">
    <div class="fila">
        <div class="labelSvt">Requirente</div>
        <div class="fieldSvt-medium" >
            ${sol.usuario.persona}
        </div>
    </div>
    <div class="fila">
        <div class="labelSvt">Unidad</div>
        <div class="fieldSvt-medium" >
            ${sol.usuario.unidad}
        </div>
    </div>
    <div class="fila">
        <div class="labelSvt">Concepto</div>
        <div class="fieldSvt-medium" >
            ${sol.concepto}
        </div>
    </div>
    <div class="fila">
        <div class="labelSvt">Fecha</div>
        <div class="fieldSvt-medium" >
            ${sol.fecha.format("dd-MM-yyyy")}
        </div>
    </div>
</div>
<div style="width: 45%;display: inline-table">

    <table class="table " border="1">
        <thead>
        <tr>
            <th>Tipo de reforma</th>
            <th>(X)</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>Reforma entre actividades por reasignación de recursos o saldos</td>
            <td class="center">
                ${sol.tipo=='R'?'X':''}
            </td>
        </tr>
        <tr>
            <td>Reforma por creación de una nueva actividad</td>
            <td class="center">
                ${sol.tipo=='N'?'X':''}
            </td>
        </tr>
        <tr>
            <td>Reforma por creación de una actividad derivada</td>
            <td class="center">
                ${sol.tipo=='D'?'X':''}
            </td>
        </tr>
        <tr>
            <td>Reforma por Incremento</td>
            <td class="center">
                ${sol.tipo=='A'?'X':''}
            </td>
        </tr>

        </tbody>
    </table>
</div>
<g:set var="ti" value="${0}"></g:set>
<g:set var="tvi" value="${0}"></g:set>
<g:set var="tvf" value="${0}"></g:set>
<g:set var="tf" value="${0}"></g:set>

<table style="margin-top: 20px;width: 972px">
    <thead>
    <tr>
        <th>Proyecto</th>
        <th>Componente</th>
        <th>No</th>
        <th>Actividad</th>
        <th>
            Grupo de <br>
            gasto
        </th>
        <th>Valor inicial</th>
        <th>Disminución</th>
        <th>Aumento</th>
        <th>Valor final</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td>${sol.origen.marcoLogico.proyecto}</td>
        <td>${sol.origen.marcoLogico.marcoLogico}</td>
        <td>${sol.fecha.format("yyyy")+'-'+sol.origen.marcoLogico.marcoLogico.numero}</td>
        <td>${sol.origen.marcoLogico}</td>
        <td>${sol.origen.presupuesto.numero}</td>
        <g:if test="${sol.tipo!='A'}">
            <td class="valor">
                <g:formatNumber number="${sol.valorOrigenSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                <g:set var="ti" value="${ti+sol.valorOrigenSolicitado}"></g:set>
            </td>
            <g:if test="${sol.tipo!='E'}">
                <td class="valor"> <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber></td>
                <g:set var="tvi" value="${tvi+sol.valor}"></g:set>
            </g:if>
            <g:else>
                <td class="valor"> <g:formatNumber number="${sol.valorOrigenSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber></td>
            </g:else>
            <td  class="valor">
                <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
            </td>
            <td class="valor">
                <g:if test="${sol.tipo!='E'}">
                    <g:formatNumber number="${sol.valorOrigenSolicitado-sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                    <g:set var="tf" value="${tvf+(sol.valorOrigenSolicitado-sol.valor)}"></g:set>
                </g:if>
                <g:else>
                    <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                %{--<g:set var="tf" value="${tf}"></g:set>--}%
                </g:else>
            </td>
        </g:if>
        <g:else>
            <td class="valor">
                <g:formatNumber number="${sol.valorOrigenSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                <g:set var="ti" value="${ti+sol.valorOrigenSolicitado}"></g:set>
            </td>
            <td class="valor">
                <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
            </td>
            <td class="valor">
                <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                <g:set var="tvf" value="${tvf+sol.valor}"></g:set>
            </td>

            <td class="valor">
                <g:formatNumber number="${sol.valorOrigenSolicitado+sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                <g:set var="tf" value="${tf+sol.valorOrigenSolicitado}"></g:set>
            </td>
        </g:else>
    </tr>
    <g:if test="${sol.tipo!='A'}">
        <tr>
            <g:if test="${sol.destino}">
                <td>${sol.destino.marcoLogico.proyecto}</td>
                <td>${sol.destino.marcoLogico.marcoLogico}</td>
                <td>${sol.fecha.format("yyyy")+'-'+sol.destino.marcoLogico.marcoLogico.numero}</td>
                <td>${sol.destino.marcoLogico}</td>
                <td>${sol.destino.presupuesto.numero}</td>
                <td class="valor">
                    <g:formatNumber number="${sol.valorDestinoSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                    <g:set var="ti" value="${ti+sol.valorDestinoSolicitado}"></g:set>
                </td>
                <td class="valor">
                    <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                </td>
                <td class="valor">
                    <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                    <g:set var="tvf" value="${tvf+sol.valor}"></g:set>
                </td>
                <td class="valor">
                    <g:formatNumber number="${sol.valorDestinoSolicitado+sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                    <g:set var="tf" value="${tf+(sol.valorDestinoSolicitado+sol.valor)}"></g:set>
                </td>
            </g:if>
            <g:else>
                <g:if test="${sol.tipo=='N'}">
                    <td>${sol.origen.marcoLogico.proyecto}</td>
                    <td>${sol.origen.marcoLogico.marcoLogico}</td>
                    <td>${sol.fecha.format("yyyy")+'-'+sol.origen.marcoLogico.marcoLogico.numero}</td>
                    <td>${sol.actividad}</td>
                    <td>${sol.presupuesto.numero}</td>
                    <td class="valor">
                        <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                    </td>
                    <td class="valor">
                        <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                    </td>
                    <td class="valor">
                        <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                        <g:set var="tvf" value="${tvf+sol.valor}"></g:set>
                    </td>
                    <td class="valor">
                        <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                    </td>
                    <g:set var="tf" value="${tf+sol.valor}"></g:set>
                </g:if>
                <g:else>
                    <td>${sol.origen.marcoLogico.proyecto}</td>
                    <td>${sol.origen.marcoLogico.marcoLogico}</td>
                    <td>${sol.fecha.format("yyyy")+'-'+sol.origen.marcoLogico.marcoLogico.numero}</td>
                    <td>${sol.origen.marcoLogico}</td>
                    <td>${sol.origen.presupuesto.numero}</td>
                    <td class="valor">
                        <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                    </td>
                    <td class="valor">
                        <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                    </td>
                    <td class="valor">
                        <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                        <g:set var="tvf" value="${tvf+sol.valor}"></g:set>
                    </td>
                    <td class="valor">
                        <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                        <g:set var="tf" value="${tf+sol.valor}"></g:set>
                    </td>
                </g:else>
            </g:else>

        </tr>
    </g:if>
    <g:else>
        <tr>
            <td colspan="5">
                Redistribución de fondos
            </td>
            <td class="valor">
                <g:set var="ti" value="${ti+sol.valor}"></g:set>
                <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
            </td>
            <td class="valor">
                <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                <g:set var="tvi" value="${tvi+sol.valor}"></g:set>
            </td>
            <td class="valor">
                <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
            </td>
            <td class="valor">
                <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber>
                <g:set var="tf" value="${tf+sol.valor}"></g:set>
            </td>
        </tr>
    </g:else>
    %{--<g:else>--}%
    %{--<g:set var="ti" value="${0}"></g:set>--}%
    %{--<g:set var="tvi" value="${0}"></g:set>--}%
    %{--<g:set var="tvf" value="${0}"></g:set>--}%
    %{--<g:set var="tf" value="${0}"></g:set>--}%
    %{--</g:else>--}%
    <tr>
        <td colspan="4"></td>
        <td style="font-weight: bold">TOTAL</td>
        <td style="font-weight: bold" class="valor"> <g:formatNumber number="${ti}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber></td>
        <td  style="font-weight: bold" class="valor"> <g:formatNumber number="${tvi}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber></td>
        <td style="font-weight: bold" class="valor"> <g:formatNumber number="${tvf}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber></td>
        <td style="font-weight: bold" class="valor"> <g:formatNumber number="${tf}" format="###,##0" minFractionDigits="2" maxFractionDigits="2" ></g:formatNumber></td>
    </tr>

    </tbody>
</table>
<fieldset style="width: 95%;height: 150px;" class="ui-corner-all">
    <legend>Observaciones</legend>
    <div class="fila">
        <textarea id="obs" style="width: 95%;height: 80px" class="ui-corner-all ui-widget-content" ${(sol.estado!=0)?'disabled':''}>${sol.observaciones}</textarea>
    </div>
</fieldset>

<g:if test="${sol.estado < 2}">
<fieldset style="width: 95%;height: 100px;" class="ui-corner-all">
    <legend>Firmas para la aprobación</legend>
    <div class="fila">
        <div class="labelSvt">Revisado por:</div>
        <div class="fieldSvt-medium">
            <g:select from="${personas}"  optionKey="id"  optionValue="persona"  id="firma1" name="firma" ></g:select>
        </div>
        <div class="labelSvt">Aprobado por:</div>
        <div class="fieldSvt-medium">
            <g:select from="${perGerencia}"  optionKey="id"  optionValue="persona"  id="firma2" name="firma" ></g:select>
        </div>
    </div>
</fieldset>
</g:if>
%{--<g:if test="${sol.estado==0}">--}%
    %{--<div class="message ui-corner-all" style="background: rgba(255, 0, 0, 0.37);width: 95%">--}%
        %{--Después de aprobar la solicitud, use las opciones del menú para realizar la modificación del P.O.A.--}%
    %{--</div>--}%
%{--</g:if>--}%
<div class="fila" style="margin-top: 40px;">
    <g:if test="${sol.estado==0}">
        <a href="#" class="btn" id="aprobar" iden="${sol.id}">Aprobar</a>
        <a href="#" style="margin-left: 20px" class="btn" id="negar" iden="${sol.id}">Negar</a>
    </g:if>
</div>

%{--<g:if test="${sol.tipo=='N'}">--}%

%{--</g:if>--}%
%{--<g:if test="${sol.tipo=='D'}">--}%

%{--</g:if>--}%
%{--<g:if test="${sol.tipo=='E'}">--}%

%{--</g:if>--}%

<script>
    $(".btn").button()
    $("#aprobar").click(function(){
        if(confirm("Está seguro?")){
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'aprobar',controller: 'modificacionesPoa')}",
                data    : {
                    id     : $("#aprobar").attr("iden"),
                    obs    : $("#obs").val(),
                    firma1: $("#firma1").val(),
                    firma2: $("#firma2").val()
                },
                success : function (msg) {
                    location.href="${g.createLink(controller: 'modificacionesPoa',action: 'listaPendientes')}"
                }
            });
        }

    })
    $("#negar").click(function(){
        if(confirm("Está seguro?")){
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'negar',controller: 'modificacionesPoa')}",
                data    : {
                    id     : $("#negar").attr("iden"),
                    obs    : $("#obs").val()
                },
                success : function (msg) {
                    location.href="${g.createLink(controller: 'modificacionesPoa',action: 'listaPendientes')}"
                }
            });
        }
    });
    $("#firma1").selectmenu({width : 200});
    $("#firma2").selectmenu({width : 200});
</script>

</body>
</html>