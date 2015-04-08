<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Procesar Solicitud de Reforma</title>

        <style type="text/css">

        th {
            background-color : #363636;
            border-color     : #ffffff;

        }

        .valor {
            text-align : right;
        }

        .center {
            text-align : center;
        }

        .table {
            border-collapse : collapse;
        }

        </style>

    </head>

    <body>

        <div class="btn-group">
            <g:link controller="modificacionesPoa" action="listaPendientes" class="btn btn-default"><i class="fa fa-bars"></i> Lista pendientes</g:link>
            <g:if test="${sol.estado == 0}">
                <a href="#" class="btn btn-success btn-sm" id="aprobar" iden="${sol.id}"><i class="fa fa-check"></i> Aprobar
                </a>
                <a href="#" class="btn btn-danger btn-sm" id="negar" iden="${sol.id}"><i class="fa fa-remove"></i> Negar
                </a>
            </g:if>
        </div>

        <div style="margin-top: 50px">
            <div style="width: 45%; float: left">
                <div class="form-group keeptogether">
                    <span class="grupo">
                        <label class="col-md-2 control-label">
                            Requirente
                        </label>

                        <div class="col-md-7">
                            ${sol.usuario.nombre + " " + sol.usuario.apellido}
                        </div>
                    </span>
                </div>

                <div class="form-group keeptogether">
                    <span class="grupo">
                        <label class="col-md-2 control-label">
                            Unidad
                        </label>

                        <div class="col-md-7">
                            ${sol.usuario.unidad}
                        </div>
                    </span>
                </div>

                <div class="form-group keeptogether">
                    <span class="grupo">
                        <label class="col-md-2 control-label">
                            Concepto
                        </label>

                        <div class="col-md-7">
                            ${sol.concepto}
                        </div>
                    </span>
                </div>

                <div class="form-group keeptogether">
                    <span class="grupo">
                        <label class="col-md-2 control-label">
                            Fecha
                        </label>

                        <div class="col-md-7">
                            ${sol.fecha.format("dd-MM-yyyy")}
                        </div>
                    </span>
                </div>
            </div>

            <div style="width: 45%; float: right">
                <table class="table table-condensed table-bordered table-striped table-hover">
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
                                ${sol.tipo == 'R' ? 'X' : ''}
                            </td>
                        </tr>
                        <tr>
                            <td>Reforma por creación de una nueva actividad</td>
                            <td class="center">
                                ${sol.tipo == 'N' ? 'X' : ''}
                            </td>
                        </tr>
                        <tr>
                            <td>Reforma por creación de una actividad derivada</td>
                            <td class="center">
                                ${sol.tipo == 'D' ? 'X' : ''}
                            </td>
                        </tr>
                        <tr>
                            <td>Reforma por Incremento</td>
                            <td class="center">
                                ${sol.tipo == 'A' ? 'X' : ''}
                            </td>
                        </tr>

                    </tbody>
                </table>
            </div>

        </div>
        <g:set var="ti" value="${0}"/>
        <g:set var="tvi" value="${0}"/>
        <g:set var="tvf" value="${0}"/>
        <g:set var="tf" value="${0}"/>

        <table class="table table-condensed table-bordered table-striped table-hover">
            <thead>
                <tr>
                    <th>Proyecto</th>
                    <th>Componente</th>
                    <th>No</th>
                    <th>Actividad</th>
                    <th>
                        Partida <br>
                        presupuestaria
                    </th>
                    <th>Valor inicial</th>
                    <th>Disminución</th>
                    <th>Aumento</th>
                    <th>Valor final</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>${sol.origen.marcoLogico.proyecto.toStringCompleto()}</td>
                    <td>${sol.origen.marcoLogico.marcoLogico.toStringCompleto()}</td>
                    <td>${sol.fecha.format("yyyy") + '-' + sol.origen.marcoLogico.numero}</td>
                    <td>${sol.origen.marcoLogico.toStringCompleto()}</td>
                    <td>${sol.origen.presupuesto.numero}</td>
                    <g:if test="${sol.tipo != 'A'}">
                        <td class="valor">
                            <g:formatNumber number="${sol.valorOrigenSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                            <g:set var="ti" value="${ti + sol.valorOrigenSolicitado}"/>
                        </td>
                        <g:if test="${sol.tipo != 'E'}">
                            <td class="valor"><g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                            <g:set var="tvi" value="${tvi + sol.valor}"/>
                        </g:if>
                        <g:else>
                            <td class="valor"><g:formatNumber number="${sol.valorOrigenSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                        </g:else>
                        <td class="valor">
                            <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                        </td>
                        <td class="valor">
                            <g:if test="${sol.tipo != 'E'}">
                                <g:formatNumber number="${sol.valorOrigenSolicitado - sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                <g:set var="tf" value="${tvf + (sol.valorOrigenSolicitado - sol.valor)}"/>
                            </g:if>
                            <g:else>
                                <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                            %{--<g:set var="tf" value="${tf}"/>--}%
                            </g:else>
                        </td>
                    </g:if>
                    <g:else>
                        <td class="valor">
                            <g:formatNumber number="${sol.valorOrigenSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                            <g:set var="ti" value="${ti + sol.valorOrigenSolicitado}"/>
                        </td>
                        <td class="valor">
                            <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                        </td>
                        <td class="valor">
                            <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                            <g:set var="tvf" value="${tvf + sol.valor}"/>
                        </td>

                        <td class="valor">
                            <g:formatNumber number="${sol.valorOrigenSolicitado + sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                            <g:set var="tf" value="${tf + sol.valorOrigenSolicitado}"/>
                        </td>
                    </g:else>
                </tr>
                <g:if test="${sol.tipo != 'A'}">
                    <tr>
                        <g:if test="${sol.destino}">
                            <td>${sol.destino.marcoLogico.proyecto.toStringCompleto()}</td>
                            <td>${sol.destino.marcoLogico.marcoLogico.toStringCompleto()}</td>
                            <td>${sol.fecha.format("yyyy") + '-' + sol.destino.marcoLogico.numero}</td>
                            <td>${sol.destino.marcoLogico.toStringCompleto()}</td>
                            <td>${sol.destino.presupuesto.numero}</td>
                            <td class="valor">
                                <g:formatNumber number="${sol.valorDestinoSolicitado}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                <g:set var="ti" value="${ti + sol.valorDestinoSolicitado}"/>
                            </td>
                            <td class="valor">
                                <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                            </td>
                            <td class="valor">
                                <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                <g:set var="tvf" value="${tvf + sol.valor}"/>
                            </td>
                            <td class="valor">
                                <g:formatNumber number="${sol.valorDestinoSolicitado + sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                <g:set var="tf" value="${tf + (sol.valorDestinoSolicitado + sol.valor)}"/>
                            </td>
                        </g:if>
                        <g:else>
                            <g:if test="${sol.tipo == 'N'}">
                                <td>${sol.origen.marcoLogico.proyecto.toStringCompleto()}</td>
                                <td>${sol.origen.marcoLogico.marcoLogico.toStringCompleto()}</td>
                                <td>${sol.fecha.format("yyyy") + '-' + sol.origen.marcoLogico.numero}</td>
                                <td>${sol.actividad}</td>
                                <td>${sol.presupuesto.numero}</td>
                                <td class="valor">
                                    <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <td class="valor">
                                    <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <td class="valor">
                                    <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                    <g:set var="tvf" value="${tvf + sol.valor}"/>
                                </td>
                                <td class="valor">
                                    <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <g:set var="tf" value="${tf + sol.valor}"/>
                            </g:if>
                            <g:else>
                                <td>${sol.origen.marcoLogico.proyecto.toStringCompleto()}</td>
                                <td>${sol.origen.marcoLogico.marcoLogico.toStringCompleto()}</td>
                                <td>${sol.fecha.format("yyyy") + '-' + sol.origen.marcoLogico.numero}</td>
                                <td>${sol.origen.marcoLogico.toStringCompleto()}</td>
                                <td>${sol.origen.presupuesto.numero}</td>
                                <td class="valor">
                                    <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <td class="valor">
                                    <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <td class="valor">
                                    <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                    <g:set var="tvf" value="${tvf + sol.valor}"/>
                                </td>
                                <td class="valor">
                                    <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                                    <g:set var="tf" value="${tf + sol.valor}"/>
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
                            <g:set var="ti" value="${ti + sol.valor}"/>
                            <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                        </td>
                        <td class="valor">
                            <g:formatNumber number="${sol.valor}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                            <g:set var="tvi" value="${tvi + sol.valor}"/>
                        </td>
                        <td class="valor">
                            <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                        </td>
                        <td class="valor">
                            <g:formatNumber number="${0}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/>
                            <g:set var="tf" value="${tf + sol.valor}"/>
                        </td>
                    </tr>
                </g:else>
                <tr>
                    <td colspan="4"></td>
                    <td style="font-weight: bold">TOTAL</td>
                    <td style="font-weight: bold" class="valor"><g:formatNumber number="${ti}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                    <td style="font-weight: bold" class="valor"><g:formatNumber number="${tvi}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                    <td style="font-weight: bold" class="valor"><g:formatNumber number="${tvf}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                    <td style="font-weight: bold" class="valor"><g:formatNumber number="${tf}" format="###,##0" minFractionDigits="2" maxFractionDigits="2"/></td>
                </tr>

            </tbody>
        </table>
        <fieldset style="width: 95%;height: 150px;" class="ui-corner-all">
            <legend>Observación</legend>

            <div class="fila">
                <textarea id="obs" style="width: 95%;height: 80px; resize: none" class="ui-corner-all ui-widget-content" ${(sol.estado != 0) ? 'disabled' : ''}>${sol.observaciones}</textarea>
            </div>
        </fieldset>

        <g:if test="${sol.estado < 2}">
            <fieldset style="width: 95%;height: 100px;" class="ui-corner-all">
                <legend>Firmas para la aprobación</legend>

                <div class="form-group keeptogether">
                    <span class="grupo">
                        <label class="col-md-2 control-label">
                            Revisado por:
                        </label>

                        <div class="col-md-3">
                            <g:select from="${personas}" class="form-control" optionKey="id" id="firma1" name="firma"/>
                        </div>
                    </span>
                    <span class="grupo">
                        <label class="col-md-2 control-label">
                            Aprobado por:
                        </label>

                        <div class="col-md-3">
                            <g:select from="${perGerencia}" class="form-control" optionKey="id" id="firma2" name="firma"/>

                        </div>
                    </span>
                </div>
            </fieldset>
        </g:if>

        <script>

            $("#aprobar").click(function () {
                bootbox.dialog({
                    title   : "Alerta",
                    message : "<i class='fa fa-check fa-3x pull-left text-success text-shadow'></i><p>" + "Está seguro de aprobar la solicitud de reforma?",
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aprobar  : {
                            label     : "<i class='fa fa-check'></i> Aprobar",
                            className : "btn-success",
                            callback  : function () {
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action:'aprobar',controller: 'modificacionesPoa')}",
                                    data    : {
                                        id     : $("#aprobar").attr("iden"),
                                        obs    : $("#obs").val(),
                                        firma1 : $("#firma1").val(),
                                        firma2 : $("#firma2").val()
                                    },
                                    success : function (msg) {
                                        location.href = "${g.createLink(controller: 'modificacionesPoa',action: 'listaPendientes')}"
                                    }
                                });
                            }
                        }
                    }
                })

            });
            $("#negar").click(function () {

                bootbox.dialog({
                    title   : "Alerta",
                    message : "<i class='fa fa-remove fa-3x pull-left text-danger text-shadow'></i><p>" + "Está seguro de negar la solicitud de reforma?",
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        negar    : {
                            label     : "<i class='fa fa-remove'></i> Negar",
                            className : "btn-danger",
                            callback  : function () {
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action:'negar',controller: 'modificacionesPoa')}",
                                    data    : {
                                        id  : $("#negar").attr("iden"),
                                        obs : $("#obs").val()
                                    },
                                    success : function (msg) {
                                        location.href = "${g.createLink(controller: 'modificacionesPoa',action: 'listaPendientes')}"
                                    }
                                });
                            }
                        }
                    }
                })

            });

        </script>

    </body>
</html>