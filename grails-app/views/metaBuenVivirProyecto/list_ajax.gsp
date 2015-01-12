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
            <g:select name="objetivo" from="${ObjetivoBuenVivir.list([sort: 'codigo'])}" optionKey="id"
                      class="form-control input-sm selectpicker"/>
        </div>

        <div class="form-group hidden" id="politicas">
            <label for="politica">Política</label>
            <g:select name="politica" from="${PoliticaBuenVivir.list([sort: 'descripcion'])}" optionKey="id"
                      class="form-control input-sm selectpicker"/>
        </div>

        <div class="form-group hidden" id="metas">
            <label for="meta">Meta</label>
            <g:select name="meta" from="${MetaBuenVivir.list([sort: 'descripcion'])}" optionKey="id"
                      class="form-control input-sm selectpicker"/>
        </div>

        <a href="#" class="btn btn-sm btn-success hidden" id="btnAddMeta"><i class="fa fa-plus"></i></a>
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

    function reloadCombo($select, tipo) {
        var objId = $select.val();

        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: "metaBuenVivirProyecto" ,action:'loadCombo_ajax')}",
            data    : {
                tipo  : tipo,
                padre : objId
            },
            success : function (msg) {
                switch (tipo) {
                    case "politica" :
                        $("#politicas").html(msg).removeClass("hidden");
                        $("#metas, #btnAddMeta").addClass("hidden");
                        reloadCombo($("#politica"), "meta");
                        break;
                    case "meta":
                        $("#metas").html(msg).removeClass("hidden");
                        $("#btnAddMeta").removeClass("hidden");
                        break;
                }
            }
        });
    }

    $(function () {
        var $obj = $("#objetivo");
        reloadTabla();
        reloadCombo($obj, "politica");
        reloadCombo($("#politicas"), "meta");
        $('.selectpicker').selectpicker({
            width      : "200px",
            limitWidth : true,
            style      : "btn-sm"
        });

        $obj.change(function () {
            reloadCombo($(this), "politica");
        });

        $("#btnAddMeta").click(function () {
            var $tbody = $("#tbMeta");
            var $selObjetivo = $("#objetivo");
            var $selPolitica = $("#politica");
            var $selMeta = $("#meta");

            var objetivoId = $selObjetivo.val();
            var politicaId = $selPolitica.val();
            var metaId = $selMeta.val();

            var existe = false;
            $tbody.children("tr").each(function () {
                var $this = $(this);
                var obj = $this.data("obj");
                var pol = $this.data("pol");
                var met = $this.data("met");
                if (obj.toString() == objetivoId && pol.toString() == politicaId && met.toString() == metaId) {
                    existe = true;
                }
            });
            if (existe) {
                $('<label id="meta-error" class="help-block text-danger" for="fuente">' +
                  'Por favor ingrese una meta no seleccionada aún' +
                  '</label>').insertAfter($(this));
            } else {
                $("#meta-error").remove();
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller:'metaBuenVivirProyecto', action:'save_ajax')}",
                    data    : {
                        "proyecto.id"      : "${proyecto.id}",
                        "metaBuenVivir.id" : metaId
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
            return false;
        });
    });
</script>