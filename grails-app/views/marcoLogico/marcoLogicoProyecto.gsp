<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 12/01/15
  Time: 04:24 PM
--%>

<%@ page import="vesta.parametros.TipoElemento; vesta.proyectos.MarcoLogico" contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Marco lógico del proyecto</title>
    </head>

    <body>

        <g:set var="editable" value="${proyecto.aprobado != 'a'}"/>

        <!-- botones -->
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="proyecto" action="list" params="${params}" class="btn btn-sm btn-default">
                    <i class="fa fa-list"></i> Lista de proyectos
                </g:link>
            </div>
            <g:if test="${editable}">
                <div class="btn-group">
                    <a href="#" class="btn btn-sm btn-success" id="btnAddComp" title="Agregar componente"
                       data-show="${componentes.size()}">
                        <i class="fa fa-plus"></i> componente
                    </a>
                </div>
            </g:if>
        </div>

        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
            <g:set var="tc" value="0"/>
            <g:each in="${componentes}" var="comp" status="k">
                <g:set var="compInfo" value="Componente ${comp.numeroComp ?: 's/n'}:
                                ${(comp?.objeto?.length() > 40) ? comp?.objeto?.substring(0, 40) + "..." : comp.objeto}"/>
                <div class="panel panel-success">
                    <div class="panel-heading" role="tab" id="headingComp${k}">
                        <h4 class="panel-title" data-toggle="collapse" data-parent="#accordion" href="#componente${k}"
                            aria-expanded="${k == params.show.toInteger() ? 'true' : 'false'}" aria-controls="componente${k}">
                            <a href="#">
                                ${compInfo}
                            </a>

                            <g:if test="${editable}">
                                <span class="btn-group pull-right">
                                    <a href="#" class="btn btn-xs btn-success btnAddAct" title="Agregar actividad"
                                       data-id="${comp.id}" data-show="${k}">
                                        <i class="fa fa-plus"></i> actividad
                                    </a>
                                    <a href="#" class="btn btn-xs btn-info btnEditComp" title="Editar componente"
                                       data-id="${comp.id}" data-show="${k}">
                                        <i class="fa fa-pencil"></i>
                                    </a>
                                    <a href="#" class="btn btn-xs btn-danger btnDeleteComp" title="Eliminar componente"
                                       data-id="${comp.id}" data-info="${compInfo}">
                                        <i class="fa fa-trash-o"></i>
                                    </a>
                                </span>
                            </g:if>
                        </h4>
                    </div>

                    <div id="componente${k}" class="panel-collapse collapse ${k == params.show.toInteger() ? 'in' : ''}"
                         role="tabpanel" aria-labelledby="headingComp${k}">
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
                                    <g:if test="${editable}">
                                        <th width="81">Acciones</th>
                                    </g:if>
                                </tr>
                            </thead>
                            <g:set var="total" value="${0}"/>
                            <g:each in="${MarcoLogico.findAllByMarcoLogicoAndEstado(comp, 0, [sort: 'numero'])}" var="act" status="l">
                                <g:set var="total" value="${total.toDouble() + act.monto}"/>
                                <tr>
                                    <td class="text-center">${act.numero}</td>
                                    <td>${act?.objeto}</td>
                                    <td class="text-right"><g:formatNumber number="${act.monto}" type="currency"/></td>
                                    <td class="text-center">${act.fechaInicio?.format('dd-MM-yyyy')}</td>
                                    <td class="text-center">${act.fechaFin?.format('dd-MM-yyyy')}</td>
                                    <td>${act.responsable?.nombre}</td>
                                    <td>${act.categoria?.descripcion}</td>
                                    <g:if test="${editable}">
                                        <td>
                                            <div class="btn-group ">
                                                <a href="#" class="btn btn-xs btn-info btnEditAct" title="Editar actividad"
                                                   data-id="${act.id}" data-show="${k}">
                                                    <i class="fa fa-pencil"></i>
                                                </a>
                                                <a href="#" class="btn btn-xs btn-danger btnDeleteAct" title="Eliminar actividad"
                                                   data-id="${act.id}" data-show="${k}" data-info="${act.objeto}">
                                                    <i class="fa fa-trash-o"></i>
                                                </a>
                                                <a href="#" class="btn btn-xs btn-warning btnCronoAct" title="Cronograma"
                                                   data-id="${act.id}" data-show="${k}">
                                                    <i class="fa fa-calendar"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </g:if>
                                </tr>
                            </g:each>
                            <tfoot>
                                <tr>
                                    <th colspan="2">Subtotal</th>
                                    <th class="text-right"><g:formatNumber number="${total}" type="currency"/></th>
                                </tr>
                            </tfoot>
                            <g:set var="tc" value="${tc.toDouble() + total}"/>
                        </table>
                    </div>
                </div>
            </g:each>
        </div>

        <div class="alert alert-info">
            <h4>TOTAL: <g:formatNumber number="${tc}" type="currency"/></h4>
        </div>

        <script type="text/javascript">
            function submitFormComponente(show) {
                var $form = $("#frmComponente");
                var $btn = $("#dlgCreateEditComponente").find("#btnSave");
                if ($form.valid()) {
                    $btn.replaceWith(spinner);
                    openLoader("Guardando Componente");
                    $.ajax({
                        type    : "POST",
                        url     : $form.attr("action"),
                        data    : $form.serialize(),
                        success : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                            setTimeout(function () {
                                if (parts[0] == "SUCCESS") {
                                    location.href = "${createLink(controller: 'marcoLogico', action: 'marcoLogicoProyecto', id:proyecto.id)}?show=" + show;
                                } else {
                                    spinner.replaceWith($btn);
                                    return false;
                                }
                            }, 1000);
                        }
                    });
                } else {
                    return false;
                } //else
            }
            function createEditComponente(show, id) {
                var title = id ? "Editar" : "Crear";
                var data = id ? {id : id} : {};
                data.proyecto = "${proyecto.id}";
                data.tipoElemento = '${TipoElemento.findByDescripcion("Componente").id}';
                data.show = show;
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller:'marcoLogico', action:'form_componente_ajax')}",
                    data    : data,
                    success : function (msg) {
                        var b = bootbox.dialog({
                            id      : "dlgCreateEditComponente",
                            title   : title + " Componente",
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
                                    label     : "<i class='fa fa-save'></i> Guardar",
                                    className : "btn-success",
                                    callback  : function () {
                                        return submitFormComponente(show);
                                    } //callback
                                } //guardar
                            } //buttons
                        }); //dialog
                        setTimeout(function () {
                            b.find(".form-control").first().focus()
                        }, 500);
                    } //success
                }); //ajax
            } //createEdit

            function submitFormActividad(show) {
                var $form = $("#frmActividad");
                var $btn = $("#dlgCreateEditActividad").find("#btnSave");
                if ($form.valid()) {
                    $btn.replaceWith(spinner);
                    openLoader("Guardando Actividad");
                    $.ajax({
                        type    : "POST",
                        url     : $form.attr("action"),
                        data    : $form.serialize(),
                        success : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                            setTimeout(function () {
                                if (parts[0] == "SUCCESS") {
                                    location.href = "${createLink(controller: 'marcoLogico', action: 'marcoLogicoProyecto', id:proyecto.id)}?show=" + show;
                                } else {
                                    spinner.replaceWith($btn);
                                    return false;
                                }
                            }, 1000);
                        }
                    });
                } else {
                    return false;
                } //else
            }
            function createEditActividad(show, componente, id) {
                var title = id ? "Editar" : "Crear";
                var data = id ? {id : id} : {};
                data.proyecto = "${proyecto.id}";
                data.tipoElemento = '${TipoElemento.findByDescripcion("Actividad").id}';
                data.show = show;
                if (componente) {
                    data.marcoLogico = componente;
                }
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller:'marcoLogico', action:'form_actividad_ajax')}",
                    data    : data,
                    success : function (msg) {
                        var b = bootbox.dialog({
                            id      : "dlgCreateEditActividad",
                            title   : title + " Actividad",
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
                                    label     : "<i class='fa fa-save'></i> Guardar",
                                    className : "btn-success",
                                    callback  : function () {
                                        return submitFormActividad(show);
                                    } //callback
                                } //guardar
                            } //buttons
                        }); //dialog
                        setTimeout(function () {
                            b.find(".form-control").first().focus()
                        }, 500);
                    } //success
                }); //ajax
            } //createEdit

            function deleteMarcoLogico(itemId, itemInfo, tipo) {
                var str = "Componente";
                var infoDel = "El componente no se eliminará si tiene actividades, metas o asignaciones asociadas.";
                if (tipo == "act") {
                    str = "Actividad";
                    infoDel = "La actividad no se eliminará si tiene metas o asignaciones asociadas.";
                }
                bootbox.dialog({
                    title   : "Alerta",
                    message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i>" +
                            "<p>¿Está seguro que desea eliminar <span class='text-danger'><strong>" + itemInfo + "</strong></span>?</p>" +
                            "<p>Esta acción no se puede deshacer.</p>" +
                            "<p>" + infoDel + "</p>",
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        eliminar : {
                            label     : "<i class='fa fa-trash-o'></i> Eliminar",
                            className : "btn-danger",
                            callback  : function () {
                                openLoader("Eliminando " + str);
                                $.ajax({
                                    type    : "POST",
                                    url     : '${createLink(controller:'marcoLogico', action:'delete_marcoLogico_ajax')}',
                                    data    : {
                                        id   : itemId,
                                        tipo : tipo
                                    },
                                    success : function (msg) {
                                        var parts = msg.split("*");
                                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                        if (parts[0] == "SUCCESS") {
                                            setTimeout(function () {
                                                location.reload(true);
                                            }, 1000);
                                        } else {
                                            closeLoader();
                                        }
                                    }
                                });
                            }
                        }
                    }
                });
            }

            $(function () {
                $("#btnAddComp").click(function () {
                    createEditComponente($(this).data("show"));
                    return false;
                });
                $(".btnEditComp").click(function () {
                    createEditComponente($(this).data("show"), $(this).data("id"));
                    return false;
                });
                $(".btnDeleteComp").click(function () {
                    deleteMarcoLogico($(this).data("id"), $(this).data("info"), "comp");
                    return false;
                });

                $(".btnAddAct").click(function () {
                    createEditActividad($(this).data("show"), $(this).data("id"));
                    return false;
                });
                $(".btnEditAct").click(function () {
                    createEditActividad($(this).data("show"), null, $(this).data("id"));
                    return false;
                });
                $(".btnDeleteAct").click(function () {
                    deleteMarcoLogico($(this).data("id"), $(this).data("info"), "act");
                    return false;
                });
            });
        </script>

    </body>
</html>