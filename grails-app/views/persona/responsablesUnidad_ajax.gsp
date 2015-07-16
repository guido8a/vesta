<%@ page import="vesta.parametros.TipoResponsable" %>
<style type="text/css">
.activo {
    background : #CCDCEA !important;
}

.pasado {
    background : #DBC3C3 !important;
}

.futuro {
    background : #EADADA !important;
}

.selected {
    background : #ECEFC9 !important;
}
</style>

<div role="tabpanel">

    <!-- Nav tabs -->
    <ul class="nav nav-pills" role="tablist">
        <li role="presentation" class="active">
            <a href="#actuales" aria-controls="actuales" role="tab" data-toggle="pill">
                Actuales
            </a>
        </li>
        <li role="presentation">
            <a href="#historial" aria-controls="historial" role="tab" data-toggle="pill">
                Historial
            </a>
        </li>
    </ul>

    <!-- Tab panes -->
    <div class="tab-content" style="margin-top: 10px;">
        <div role="tabpanel" class="tab-pane active" id="actuales">
            <g:if test="${usuarios.size() > 0}">
                <div class="btn-toolbar" role="toolbar">
                    <div class="btn-group" role="group">
                        <a href="#" class="btn btn-success btn-sm" id="btnAddResp">
                            <i class="fa fa-plus"></i> Agregar
                        </a>
                    </div>
                </div>

                <div id="divTablaResponsables"></div>
            </g:if>
            <g:else>
                <div class="alert alert-danger">
                    <i class="fa fa-warning fa-3x text-shadow pull-left"></i> <h4>Atención</h4>

                    <p>
                        No existen usuarios en esta Área de gestión. Agregue usuarios para poder asignar responsables.
                    </p>
                </div>
            </g:else>
        </div>

        <div role="tabpanel" class="tab-pane" id="historial">
            <table class="table table-bordered table-hover table-condensed">
                <thead>
                    <tr>
                        <th>Responsable</th>
                        <th>Desde</th>
                        <th>Hasta</th>
                        <th>Tipo</th>
                        <th>Observaciones</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <g:if test="${responsableProyectoInstanceList.size() > 0}">
                        <g:each in="${responsableProyectoInstanceList}" status="i" var="responsableProyectoInstance">
                            <tr class="${(i % 2) == 0 ? 'odd' : 'even'} ${responsableProyectoInstance.clase}">
                                <td>
                                    ${responsableProyectoInstance.obj?.responsable?.nombre} ${responsableProyectoInstance.obj?.responsable?.apellido}
                                </td>
                                <td>
                                    <g:formatDate date="${responsableProyectoInstance.obj?.desde}" format="dd-MM-yyyy"/>
                                </td>
                                <td>
                                    <g:formatDate date="${responsableProyectoInstance.obj?.hasta}" format="dd-MM-yyyy"/>
                                </td>
                                <td>
                                    ${responsableProyectoInstance.obj?.tipo}
                                </td>
                                <td>
                                    ${responsableProyectoInstance.obj?.observaciones}
                                </td>
                                <td>
                                    ${responsableProyectoInstance?.estado?.capitalize()}
                                </td>
                            </tr>
                        </g:each>
                    </g:if>
                    <g:else>
                        <tr class="info text-info text-shadow text-center">
                            <td colspan="6">
                                <h4>
                                    <a class="fa icon-ghost fa-2x"></a>
                                    No se encontraron responsables para esta Área de gestión
                                </h4>
                            </td>
                        </tr>
                    </g:else>
                </tbody>
            </table>
        </div>

    </div>

</div>

<script type="text/javascript">
    function submitFormResponsable() {
        var $form = $("#frmResponsable");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Responsable");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize() + "&unidad=${unidad.id}",
                success : function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    closeLoader();
                    if (parts[0] == "SUCCESS") {
                        reloadTablaResponsables();
                    } else {
                        return false;
                    }
                }
            });
        } else {
            return false;
        } //else
    }

    function reloadTablaResponsables() {
        var $divTablaResponsables = $("#divTablaResponsables");
        var url = "${resource(dir:'images/spinners', file:'spinner_24.GIF')}";
        $divTablaResponsables.html("<img src='" + url + "' />");
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'tablaResponsables_ajax')}",
            data    : {
                id : "${unidad.id}"
            },
            success : function (msg) {
                $divTablaResponsables.html(msg);
            }
        });
    }

    $(function () {
        reloadTablaResponsables();
        $("#btnAddResp").click(function () {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'formResponsable_ajax')}",
                data    : {
                    id : "${unidad.id}"
                },
                success : function (msg) {
                    var b = bootbox.dialog({
                        id      : "dlgCreateEdit",
                        title   : "Agregar responsable",
                        class   : "modal-lg",
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
                                    return submitFormResponsable();
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                    setTimeout(function () {
                        b.find(".form-control").first().focus()
                    }, 500);
                } //success
            }); //ajax
        });
    });
</script>