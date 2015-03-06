<%@ page import="vesta.parametros.poaPac.Anio; vesta.parametros.poaPac.Fuente" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<div class="alert alert-success">
    <form class="form-inline" id="frmFinanciamiento">
        <div class="form-group">
            <label for="fuente">Fuente</label>
            <g:select name="fuente" from="${Fuente.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion"
                      class="form-control input-sm" style="width:250px;"/>
        </div>

        <div class="form-group">
            <label for="monto">Monto</label>

            <div class="input-group input-group-sm">
                <g:textField name="monto" class="form-control input-sm required number money" style="width:150px;"/>
                <span class="input-group-addon"><i class="fa fa-usd"></i></span>
            </div>
        </div>

        <div class="form-group">
            <label for="anio">Año</label>
            <g:select name="anio" from="${Anio.list([sort: 'anio', order: 'asc'])}" optionKey="id" optionValue="anio"
                      class="form-control input-sm" value="${Anio.findByAnio(new Date().format('yyyy')).id}"/>
        </div>

        <a href="#" class="btn btn-sm btn-success" id="btnAddFin"><i class="fa fa-plus"></i></a>
    </form>
</div>

<div class="row">
    <div class="col-md-2 show-label">Total del proyecto</div>

    <div class="col-md-10"><g:formatNumber number="${proyecto.monto.toDouble()}" type="currency" currencySymbol=""/></div>
</div>

<div id="tabla"></div>

<div class="row">
    <div class="col-md-2 show-label">Restante</div>

    <div class="col-md-10" id="divResto"></div>
</div>

<script type="text/javascript">
    var total = parseFloat("${proyecto.monto}");
    var suma = 0;
    var restante = 0;

    function setSuma(val) {
        suma = val;
        var totalPorc = (100 * suma) / total;
        $("#tfSuma").text("$" + number_format(suma, 2, ".", ","));
        $("#tfPorc").text(number_format(totalPorc, 2, ".", ",") + "%");
    }
    function setRestante(val) {
        restante = val;
        $("#divResto").text("$" + number_format(restante, 2, ".", ","));
    }

    function reloadTabla() {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'financiamiento', action:'tablaFinanciamientosProyecto_ajax')}",
            data    : {
                id : "${proyecto.id}"
            },
            success : function (msg) {
                $("#tabla").html(msg);
                $("#fuente").find("option").first().attr("selected", true);
                $("#monto").val("");
            }
        });
    }

    $(function () {
        reloadTabla();
        var $frm = $("#frmFinanciamiento");
        $frm.validate({
            errorClass     : "help-block text-danger",
            errorPlacement : function (error, element) {
                if (element.parent().hasClass("input-group")) {
                    error.insertAfter(element.parent());
                } else {
                    error.insertAfter(element);
                }
                element.parents(".grupo").addClass('has-error');
            },
            success        : function (label) {
                label.parents(".grupo").removeClass('has-error');
label.remove();
            },
            rules          : {
                monto : {
                    tdnMax : function () {
                        return parseFloat(number_format(restante, 2, ".", ""));
                    }
                }
            },
            messages       : {
                monto : {
                    tdnMax : "Por favor ingrese un valor inferior al restante"
                }
            }
        });
        $("#btnAddFin").click(function () {
            if ($frm.valid()) {
                var $tbody = $("#tbFin");
                var $selFuente = $("#fuente");
                var $selAnio = $("#anio");
                var fuenteId = $selFuente.val();
                var anioId = $selAnio.val();
                var monto = $.trim($("#monto").val());
                monto = parseFloat(str_replace(",", "", monto));
                var existe = false;
                $tbody.children("tr").each(function () {
                    var $this = $(this);
                    var fuente = $this.data("fuente");
                    var anio = $this.data("anio");
                    if (fuente.toString() == fuenteId && anio.toString() == anioId) {
                        existe = true;
                    }
                });
                if (existe) {
                    $('<label id="fuente-error" class="help-block text-danger" for="fuente">' +
                      'Por favor ingrese una combinación de fuente y año no seleccionadas aún' +
                      '</label>').insertAfter($(this));
                } else {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller:'financiamiento', action:'save_ajax')}",
                        data    : {
                            id     : "${proyecto.id}",
                            anio   : anioId,
                            fuente : fuenteId,
                            monto  : monto
                        },
                        success : function (msg) {
                            var parts = msg.split("*");
                            log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                            if (parts[0] == "SUCCESS") {
                                reloadTabla();
                            }
                        }
                    });
                }
            }
            return false;
        });
    });
</script>