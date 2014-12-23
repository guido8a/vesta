<%@ page import="vesta.seguridad.Prms; vesta.seguridad.Modulo; vesta.seguridad.Tpac" %>

<script src="${resource(dir: 'js/plugins/fixed-header-table-1.3', file: 'jquery.fixedheadertable.js')}"></script>
<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/plugins/fixed-header-table-1.3/css', file: 'defaultTheme.css')}"/>

<style type="text/css">
.check {
    cursor: pointer;
}
</style>

<p>
    Permisos asignados al perfil <strong>${perfil.nombre}</strong>
</p>

<table id="tblPermisos" class="table table-bordered table-condensed table-hover">
    <thead>
        <tr>
            <th width="10%">
                Permiso
                <a href="#" title="Guardar todos los permisos modificados" class="btn btn-save-perm btn-success btn-sm pull-right">
                    <i class="fa fa-save"></i>
                </a>
            </th>
            <th width="25%">Acción</th>
            <th width="30%">Nombre</th>
            <th width="20%">Controlador</th>
            <th width="15%">Tipo</th>
        </tr>
    </thead>
    <tbody>
        <g:each in="${acciones}" var="accion" status="i">
            <g:set var="esMenu" value="${accion.tipo.codigo == 'M'}"/>
            <g:set var="cantPermisos" value="${Prms.countByAccionAndPerfil(accion, perfil)}"/>
            <tr class="${esMenu ? 'success' : 'info'}">
                <td data-id="${accion.id}" class="text-center check ${cantPermisos > 0 ? 'checked' : ''}">
                    <i class="fa ${cantPermisos > 0 ? 'fa-check-square-o' : 'fa-square-o'}"></i>
                </td>
                <td>
                    ${accion.nombre}
                </td>
                <td>
                    ${accion.descripcion}
                </td>
                <td>
                    ${accion.control.nombre}
                </td>
                <td>
                    ${accion.tipo.tipo}
                </td>
            </tr>
        </g:each>
    </tbody>
</table>

<script type="text/javascript">

    $("#tblPermisos").fixedHeaderTable({
        height    : 280,
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

    $(".check").click(function () {
        var $this = $(this);
        if ($this.hasClass("checked")) {
            $this.removeClass("checked");
            $this.find("i").removeClass("fa-check-square-o").addClass("fa-square-o")
        } else {
            $this.addClass("checked");
            $this.find("i").removeClass("fa-square-o").addClass("fa-check-square-o")
        }
    });

    $(".btn-save-perm").click(function () {
        var perfil = "${perfil.id}";
        var acciones = "";
        $(".checked").each(function () {
            console.log($(this).data("id"));
        });
        console.log(perfil);
        return false;
    });

</script>