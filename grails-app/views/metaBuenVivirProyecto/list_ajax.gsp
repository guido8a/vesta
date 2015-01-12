<%@ page import="vesta.proyectos.MetaBuenVivir; vesta.proyectos.PoliticaBuenVivir; vesta.proyectos.ObjetivoBuenVivir; vesta.parametros.poaPac.Anio; vesta.parametros.poaPac.Fuente" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"></script>
<link href="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.min.css')}" rel="stylesheet">

<style type="text/css">
.tdn-select-opt {
    border-bottom : solid 1px #aaa;
    font-size     : 9pt;
}
</style>

<div class="alert alert-success">
    <form class="form-inline" id="frmMetas">
        <div class="form-group">
            <label for="objetivo">Objetivo</label>
            <g:select name="objetivo" from="${ObjetivoBuenVivir.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion"
                      class="form-control input-sm selectpicker"/>
        </div>

        <div class="form-group">
            <label for="politica">Política</label>
            <g:select name="politica" from="${PoliticaBuenVivir.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion"
                      class="form-control input-sm selectpicker"/>
        </div>

        <div class="form-group">
            <label for="meta">Meta</label>
            <g:select name="meta" from="${MetaBuenVivir.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion"
                      class="form-control input-sm selectpicker"/>
        </div>

        <a href="#" class="btn btn-sm btn-success" id="btnAddFin"><i class="fa fa-plus"></i></a>
    </form>
</div>

<div id="tabla"></div>

<script type="text/javascript">

    function reloadTabla() {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'metaBuenVivirProyecto', action:'tablaMetasProyecto_ajax')}",
            data    : {
                id : "${proyecto.id}"
            },
            success : function (msg) {
                $("#tabla").html(msg);
            }
        });
    }

    $(function () {
        reloadTabla();
        $('.selectpicker').selectpicker({
            width : "200px",
            style : "btn-sm"
        });
        var $frm = $("#frmMetas");
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