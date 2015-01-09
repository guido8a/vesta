<%@ page import="vesta.parametros.proyectos.GrupoProcesos" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<div class="btn-toolbar toolbar">

    <div class="btn-group">
        <a href="#" class="btn btn-sm btn-success" id="btnAddDoc">
            <i class="fa fa-plus"></i> Agregar
        </a>
    </div><!-- /input-group -->
%{--<div class="btn-group">--}%
%{--<a class="btn btn-sm btn-danger">--}%
%{--<i class="fa fa-trash-o"></i> Eliminar--}%
%{--</a>--}%
%{--</div><!-- /input-group -->--}%

    <div class="btn-group col-md-3 pull-right">
        <div class="input-group input-group-sm">
            <input type="text" class="form-control input-sm " id="searchDoc" placeholder="Buscar"/>
            <span class="input-group-btn">
                <a href="#" class="btn btn-default" id="btnSearchDoc"><i class="fa fa-search"></i></a>
            </span>
        </div><!-- /input-group -->
    </div>
</div>

<div id="tabla"></div>

<script type="text/javascript">
    function reloadTablaDocumento(search) {
        var data = {
            id : "${proyecto.id}"
        };
        if (search) {
            data.search = search;
        }
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'documento', action:'tablaDocumentosProyecto_ajax')}",
            data    : data,
            success : function (msg) {
                $("#tabla").html(msg);
            }
        });
    }
    function submitFormDocumento() {
        var $form = $("#frmDocumento");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Documento");
            var formData = new FormData($form[0]);
            $.ajax({
                url         : $form.attr("action"),
                type        : 'POST',
                data        : formData,
                async       : false,
                success     : function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    closeLoader();
                    if (parts[0] == "SUCCESS") {
                        reloadTablaDocumento();
                    } else {
                        spinner.replaceWith($btn);
                        return false;
                    }
                },
                error       : function () {

                },
                cache       : false,
                contentType : false,
                processData : false
            });
        } else {
            return false;
        } //else
    }
    function deleteDocumento(itemId) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>" +
                      "¿Está seguro que desea eliminar el Documento seleccionado? Esta acción no se puede deshacer.</p>",
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
                        openLoader("Eliminando Documento");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller:'documento', action:'delete_ajax')}',
                            data    : {
                                id : itemId
                            },
                            success : function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                closeLoader();
                                if (parts[0] == "SUCCESS") {
                                    reloadTablaDocumento();
                                }
                            }
                        });
                    }
                }
            }
        });
    }
    function createEditDocumento(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? { id : id } : {};
        data.proyecto = "${proyecto.id}";
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'documento', action:'form_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Documento",
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
                                return submitFormDocumento();
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
    function downloadDocumento(id) {
        location.href = "${createLink(controller: 'documento', action: 'downloadDoc')}/" + id;
    }

    $(function () {
        reloadTablaDocumento();

        $("#btnSearchDoc").click(function () {
            reloadTablaDocumento($.trim($("#searchDoc").val()));
        });
        $("#searchDoc").keyup(function (ev) {
            if (ev.keyCode == 13) {
                reloadTablaDocumento($.trim($("#searchDoc").val()));
            }
        });
        $("#btnAddDoc").click(function () {
            createEditDocumento();
        });

    });
</script>