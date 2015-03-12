<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 12/01/15
  Time: 04:24 PM
--%>

<%@ page import="vesta.proyectos.MarcoLogicoRespaldo; vesta.parametros.TipoElemento; vesta.proyectos.MarcoLogico" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Plan de Proyecto</title>
</head>

<body>



<!-- botones -->
<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:link controller="marcoLogico" action="listaRespaldos" id="${resp.proyecto.id}" class="btn btn-sm btn-default">
            <i class="fa fa-list"></i> Regresar
        </g:link>
    </div>


</div>


<g:if test="${componentes.size() > 0}">
    <elm:container tipo="horizontal" titulo="Respaldo ${resp.descripcion}, al ${resp.fecha.format('dd-MM-yyyy')}">
    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
        <g:set var="tc" value="0"/>
        <g:each in="${componentes}" var="comp" status="k">
            <g:set var="compInfo" value="Componente ${comp.numeroComp ?: 's/n'}:
                                ${(comp?.objeto?.length() > 40) ? comp?.objeto?.substring(0, 40) + "..." : comp.objeto}"/>
            <div class="panel panel-success">
                <div class="panel-heading" role="tab" id="headingComp${k + 1}">
                    <h4 class="panel-title" data-toggle="collapse" data-parent="#accordion" href="#componente${k + 1}"
                        aria-expanded="true" aria-controls="componente${k + 1}">
                        <a href="#">
                            ${compInfo}
                        </a>

                    </h4>
                </div>

                <div id="componente${k + 1}" class="panel-collapse collapse "
                     role="tabpanel" aria-labelledby="headingComp${k + 1}">
                    <table class="table table-bordered table-condensed table-hover">
                        <thead>
                        <tr>
                            <th width="45">#</th>
                            <th>Actividad</th>
                            <th width="125">Monto</th>
                            <th width="110">Inicio</th>
                            <th width="110">Fin</th>
                            <th width="120">Responsable</th>
                            <th width="110">Categoría</th>
                            %{--<g:if test="${editable}">--}%
                            %{--<th width="100">Acciones</th>--}%
                            %{--</g:if>--}%
                        </tr>
                        </thead>
                        <tbody>
                        <g:set var="total" value="${0}"/>
                        <g:each in="${MarcoLogicoRespaldo.findAllByMarcoLogico(comp,  [sort: 'numero'])}" var="act" status="l">
                            <g:set var="total" value="${total.toDouble() + act.monto}"/>
                            <tr data-id="${act.id}" data-show="${k + 1}" data-info="${act.objeto}">
                                <td class="text-center">${act.numero}</td>
                                <td>${act?.objeto}</td>
                                <td class="text-right"><g:formatNumber number="${act.monto}" type="currency" currencySymbol=""/></td>
                                <td class="text-center">${act.fechaInicio?.format('dd-MM-yyyy')}</td>
                                <td class="text-center">${act.fechaFin?.format('dd-MM-yyyy')}</td>
                                <td>${act.responsable?.nombre}</td>
                                <td>${act.categoria?.descripcion}</td>

                                %{--</g:if>--}%
                            </tr>
                        </g:each>
                        </tbody>
                        <tfoot>
                        <tr>
                            <th colspan="2">Subtotal</th>
                            <th class="text-right"><g:formatNumber number="${total}" type="currency" currencySymbol=""/></th>
                        </tr>
                        </tfoot>
                        <g:set var="tc" value="${tc.toDouble() + total}"/>
                    </table>
                </div>
            </div>
        </g:each>
    </div>

    <div class="alert alert-info">
        <h4>TOTAL: <g:formatNumber number="${tc}" type="currency" currencySymbol=""/></h4>
    </div>

</elm:container>
</g:if>
</body>
</html>