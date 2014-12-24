<%@ page import="vesta.seguridad.Modulo; vesta.seguridad.Tpac" %>

<script src="${resource(dir: 'js/plugins/fixed-header-table-1.3', file: 'jquery.fixedheadertable.js')}"></script>
<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/plugins/fixed-header-table-1.3/css', file: 'defaultTheme.css')}"/>

<table id="tblAcciones" class="table table-bordered table-condensed table-hover">
    <thead>
        <tr>
            <th width="19%">Acción</th>
            <th width="27%">
                Nombre
                <a href="#" title="Guardar todos los nombre modificados" class="btn btn-save-desc btn-success btn-sm pull-right">
                    <i class="fa fa-save"></i>
                </a>
            </th>
            <th width="15%">Controlador</th>
            <th width="25%">Módulo
                <a href="#" title="Guardar todos los módulos modificados" class="btn btn-save-mod btn-success btn-sm pull-right">
                    <i class="fa fa-save"></i>
                </a>
            </th>
            <th width="14%">Tipo</th>
        </tr>
    </thead>
    <tbody>
        <g:each in="${acciones}" var="accion" status="i">
            <g:set var="esMenu" value="${accion.tipo.codigo == 'M'}"/>
            <tr class="${esMenu ? 'success' : 'info'}">
                <td>
                    ${accion.nombre}
                </td>
                <td>
                    <input type="text" data-original="${accion.descripcion}" data-id="${accion.id}" class="form-control input-sm input-sm input-desc"
                           value="${accion.descripcion}" tabindex="${i + 1}"/>
                </td>
                <td>
                    ${accion.control.nombre}
                </td>
                <td>
                    <g:select name="modulo" from="${Modulo.list([sort: 'nombre'])}" optionKey="id" optionValue="nombre" data-id="${accion.id}"
                              value="${accion.modulo.id}" class="form-control input-sm input-sm select-mod" data-original="${accion.modulo.id}"
                              tabindex="${i + 1 + acciones.size()}"/>
                </td>
                <td>
                    <a href="#" class="btn btn-switch btn-xs ${esMenu ? 'btn-info' : 'btn-success'}" data-id="${accion.id}"
                       title="Cambiar a ${esMenu ? 'proceso' : 'menú'}" data-tipo="${accion.tipo.codigo}">
                        <i class="fa ${esMenu ? 'fa-cog' : 'fa-navicon'}"></i>
                    </a>
                    <span class="tipo-lbl">
                        ${accion.tipo.tipo}
                    </span>
                </td>
            </tr>
        </g:each>
    </tbody>
</table>

<script type="text/javascript">

    $("#tblAcciones").fixedHeaderTable({
        height    : 320,
        autoResize: true,
        footer    : true
    });

    $('[title!=""]').qtip({
        style   : {
            classes: 'qtip-tipsy'
        },
        position: {
            my: "bottom center",
            at: "top center"
        }
    });

    $(".select-mod").change(function () {
        var $this = $(this);
        var valOrig = $.trim($this.data("original"));
        var val = $.trim($this.val());
        if (valOrig != val) {
            $this.parents("tr").addClass("warning");
            $this.addClass("select-changed");
        } else {
            $this.parents("tr").removeClass("warning");
            $this.removeClass("select-changed");
        }
    });

    $(".input-desc").blur(function () {
        var $this = $(this);
        var valOrig = $.trim($this.data("original"));
        var val = $.trim($this.val());
        if (valOrig != val) {
            $this.parents("tr").addClass("warning");
            $this.addClass("input-changed");
        } else {
            $this.parents("tr").removeClass("warning");
            $this.removeClass("input-changed");
        }
    });

    $(".btn-save-desc").click(function () {
        var data = {};
        $(".input-changed").each(function () {
            var $input = $(this);
            data["desc_" + $input.data("id")] = $input.val();
        });
        openLoader("Guardando");
        $.ajax({
            type   : "POST",
            url    : "${createLink(controller:'acciones', action:'accionCambiarNombre_ajax')}",
            data   : data,
            success: function (msg) {
                var parts = msg.split("*");
                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                closeLoader();
                if (parts[0] == "SUCCESS") {
                    $("tr.warning").removeClass("warning");
                    $(".input-changed").each(function () {
                        var $input = $(this);
                        $input.data("original", $input.val()).removeClass("input-changed");
                    });
                }
            }
        });
        return false;
    });

    $(".btn-save-mod").click(function () {
        var data = {};
        $(".select-changed").each(function () {
            var $input = $(this);
            data["mod_" + $input.data("id")] = $input.val();
        });
        openLoader("Guardando");
        $.ajax({
            type   : "POST",
            url    : "${createLink(controller:'acciones', action:'accionCambiarModulo_ajax')}",
            data   : data,
            success: function (msg) {
                var parts = msg.split("*");
                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                closeLoader();
                if (parts[0] == "SUCCESS") {
                    $(".select-changed").each(function () {
                        var $input = $(this);
                        $input.parents("tr").remove();
                    });
                }
            }
        });
        return false;
    });

    $(".btn-switch").click(function () {
        var $this = $(this);
        var id = $this.data("id");
        var tipo = $this.data("tipo");
//            console.log(id, tipo);
        if (tipo == "M") {
            tipo = "P";
        } else if (tipo == "P") {
            tipo = "M";
        }
        $.ajax({
            type   : "POST",
            url    : "${createLink(controller:'acciones', action:'accionCambiarTipo_ajax')}",
            data   : {
                id  : id,
                tipo: tipo
            },
            success: function (msg) {
                var parts = msg.split("*");
                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                if (parts[0] == "SUCCESS") {
                    if (tipo == 'M') {
                        $this.parents("tr").removeClass("info").addClass("success");
                        $this.removeClass("btn-success").addClass("btn-info");
                        $this.attr("title", "Cambiar a proceso");
                        $this.find("i").removeClass("fa-navicon").addClass("fa-cog");
                        $this.data("tipo", "M");
                        $this.parents("td").find(".tipo-lbl").text("Menú");
                    } else {
                        $this.parents("tr").removeClass("success").addClass("info");
                        $this.removeClass("btn-info").addClass("btn-success");
                        $this.attr("title", "Cambiar a menú");
                        $this.find("i").removeClass("fa-cog").addClass("fa-navicon");
                        $this.data("tipo", "P");
                        $this.parents("td").find(".tipo-lbl").text("Proceso");
                    }
                }
            }
        });
        return false;
    });

    %{--$(".btn-save").click(function () {--}%
    %{--var $btn = $(this);--}%
    %{--var val = $btn.parent().prev().val();--}%
    %{--var id = $btn.data("id");--}%
    %{--$.ajax({--}%
    %{--type   : "POST",--}%
    %{--url    : "${createLink(controller:'acciones', action:'accionCambiarNombre_ajax')}",--}%
    %{--data   : {--}%
    %{--id         : id,--}%
    %{--descripcion: val--}%
    %{--},--}%
    %{--success: function (msg) {--}%
    %{--var parts = msg.split("*");--}%
    %{--log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)--}%
    %{--}--}%
    %{--});--}%
    %{--return false;--}%
    %{--});--}%

    %{--$(".switch").bootstrapSwitch({--}%
    %{--onColor       : "success",--}%
    %{--offColor      : "info",--}%
    %{--onText        : "Menú",--}%
    %{--offText       : "Proceso",--}%
    %{--size          : "small",--}%
    %{--onSwitchChange: function (event, state) {--}%
    %{--//menu    : state true--}%
    %{--//proceso : state false--}%
    %{--var tipo = 'M';--}%
    %{--var id = $(this).data("id");--}%
    %{--if (state) {--}%
    %{--$(this).parents("tr").removeClass("info").addClass("success");--}%
    %{--} else {--}%
    %{--$(this).parents("tr").removeClass("success").addClass("info");--}%
    %{--tipo = 'P';--}%
    %{--}--}%
    %{--$.ajax({--}%
    %{--type   : "POST",--}%
    %{--url    : "${createLink(controller:'acciones', action:'accionCambiarTipo_ajax')}",--}%
    %{--data   : {--}%
    %{--id  : id,--}%
    %{--tipo: tipo--}%
    %{--},--}%
    %{--success: function (msg) {--}%
    %{--var parts = msg.split("*");--}%
    %{--log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)--}%
    %{--}--}%
    %{--});--}%
    %{--}--}%
    %{--});--}%
</script>