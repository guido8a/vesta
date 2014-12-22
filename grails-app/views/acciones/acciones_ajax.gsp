<%@ page import="vesta.seguridad.Tpac" %>

<script src="${resource(dir: 'js/plugins/fixed-header-table-1.3', file: 'jquery.fixedheadertable.js')}"></script>
<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/plugins/fixed-header-table-1.3/css', file: 'defaultTheme.css')}"/>

<table id="tblAcciones" class="table table-bordered table-condensed table-hover">
    <thead>
        <tr>
            <th width="5%">Permisos</th>
            <th width="20%">Acción</th>
            <th width="27%">Nombre</th>
            <th width="20%">Controlador</th>
            <th width="28%">Tipo</th>
        </tr>
    </thead>
    <tbody>
        <g:each in="${acciones}" var="accion">
            <tr class="${accion.tipo.codigo == 'M' ? 'success' : 'info'}">
                <td>
                    check
                </td>
                <td>
                    ${accion.nombre}
                </td>
                <td>
                    <div class="input-group">
                        <input type="text" class="form-control input-sm" value="${accion.descripcion}">
                        <span class="input-group-btn">
                            <a href="#" class="btn btn-success btn-sm btn-save" data-id="${accion.id}">
                                <i class="fa fa-save"></i>
                            </a>
                        </span>
                    </div><!-- /input-group -->
                </td>
                <td>
                    ${accion.control.nombre}
                </td>
                <td>
                    <input data-id="${accion.id}" type="checkbox" class="switch" ${accion.tipo.codigo == 'M' ? 'checked' : ''}/>
                    %{--<g:select name="tipo" from="${Tpac.list([sort: 'tipo'])}" optionKey="id" optionValue="tipo"--}%
                    %{--class="form-control input-sm" value="${accion.tipo.id}"/>--}%
                    %{--<a href="#" class="btn btn-success btn-sm">--}%
                    %{--<i class="fa fa-save"></i>--}%
                    %{--</a>--}%
                </td>
            </tr>
        </g:each>
    </tbody>
</table>

<script type="text/javascript">
    $(function () {
        $(".btn-save").click(function () {
            var $btn = $(this);
            var val = $btn.parent().prev().val();
            var id = $btn.data("id");
            $.ajax({
                type   : "POST",
                url    : "${createLink(controller:'acciones', action:'accionCambiarNombre_ajax')}",
                data   : {
                    id         : id,
                    descripcion: val
                },
                success: function (msg) {
                    var parts = msg.split("*");
                    log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                }
            });
            return false;
        });

        $("#tblAcciones").fixedHeaderTable({
            height    : 330,
            autoResize: true,
            footer    : true
        });

        $(".switch").bootstrapSwitch({
            onColor       : "success",
            offColor      : "info",
            onText        : "Menú",
            offText       : "Proceso",
            size          : "small",
            onSwitchChange: function (event, state) {
                //menu    : state true
                //proceso : state false
                var tipo = 'M';
                var id = $(this).data("id");
                if (state) {
                    $(this).parents("tr").removeClass("info").addClass("success");
                } else {
                    $(this).parents("tr").removeClass("success").addClass("info");
                    tipo = 'P';
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
                    }
                });
            }
        });
    });
</script>