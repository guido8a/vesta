<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 22/12/14
  Time: 04:36 PM
--%>

<style type="text/css">
</style>

<input type="button" class="botonNuevo nuevo" id="${catalogo}" value="Crear Item"/>

<g:form action="grabar" method="post" style="margin-top: 10px;">
    <input type="hidden" id="mdlo__id" value="${mdlo__id}">
    <input type="hidden" id="tpac__id" value="${mdlo__id}">
    <g:if test="${datos?.size()>0}">
        <div class="ui-corner-all" style="width: 940px; height: 520px; overflow:auto; margin-bottom: 5px; margin-left: -10px; background-color: #efeff8;
        border-style: solid; border-color: #AAA; border-width: 1px; ">
            <table class="table table-condensed table-bordered table-striped table-hover">
                <thead style="color: #101010; background-color: #69b0e3" >
                <tr>
                    <th style="width:100px">Código</th>
                    <th style="width:400px">Descripción</th>
                    <th style="width:100px">Estado</th>
                    <th style="width:80px">Orden</th>
                    <th style="width:100px">Original</th>
                </tr>
                </thead>
                <tbody>
                <!-- <hr>Hola ${lista}</hr> -->
                <g:each in="${datos}" status="i" var="d">
                    <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" iden="${d[0]}"  style="height: 27px;">
                        %{--<tr class="${(i % 2) == 0 ? 'odd' : 'even'}" style="background: ${(d[0]) ? '#a0c9e2' : ''}">--}%
                        <td>${d[1]?.encodeAsHTML()}</td>
                        <td>${d[2]?.encodeAsHTML()}</td>
                        <td>${d[3]?.encodeAsHTML()}</td>
                        <td>${d[4]?.encodeAsHTML()}</td>
                        <td>${d[5]?.encodeAsHTML()}</td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </g:if>
</g:form>

<script type="text/javascript">
    $(document).ready(function() {
        $("#aceptar").click(function() {
//            alert("ohhhhh")
        });
    });

    $(".nuevo").click(function() {
        var catalogo = ${catalogo}
        bootbox.confirm("Crear un nuevo Item del Catálogo: ${vesta.parametros.Catalogo.get(catalogo).nombre} ?", function (result){
            if(result == true){
                createEditRow();
            }
        });
    });

    function armarAccn() {
        var datos = new Array()
        $('[type=checkbox]:checked').each(
                /*$(':checkbox[checked="true"]').each(*/
                function() {
                    datos.push($(this).val());
                }
        )
        datos += "&menu=" + $('#mdlo__id').val() + "&grabar=S"
        return datos
    }

    var id = null;
    function submitForm() {
        var $form = $("#frmItem");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            $btn.replaceWith(spinner);
            openLoader("Guardando Item");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                    setTimeout(function() {
                        if (parts[0] == "SUCCESS") {
                            location.reload(true);
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


    function createEditRow(id) {
        var title = id ? "Editar" : "Crear";
//        var data = id ? { id: id } : {};
        var data = "&cata=" + $("#catalogo").val() + "&id=" + id;
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'form_item')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " Item",
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
                                return submitForm();
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


    function deleteRow(itemId) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i><p>" +
            "¿Está seguro que desea eliminar el item del catálogo seleccionado? Esta acción no se puede deshacer.</p>",
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
                        openLoader("Eliminando Item");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller: 'itemCatalogo', action:'borrarItem')}',
                            data    : {
                                id : itemId
                            },
                            success : function (msg) {
                                var parts = msg.split("*");
                                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                                if (parts[0] == "SUCCESS") {
                                    setTimeout(function() {
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
        $("tbody>tr").contextMenu({
            items  : {
                header   : {
                    label  : "Acciones",
                    header : true
                },
                editar   : {
                    label  : "Editar",
                    icon   : "fa fa-pencil",
                    action : function ($element) {
                        var id = $element.attr("iden");
                        createEditRow(id);
                    }
                },
                eliminar : {
                    label            : "Eliminar",
                    icon             : "fa fa-trash-o",
                    separator_before : true,
                    action           : function ($element) {
//                        var id = $element.data("id");
                        var id = $element.attr("iden");
                        deleteRow(id);
                    }
                }
            },
            onShow : function ($element) {
                $element.addClass("success");
            },
            onHide : function ($element) {
                $(".success").removeClass("success");
            }
        });
    });




</script>