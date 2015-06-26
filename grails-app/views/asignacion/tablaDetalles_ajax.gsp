l<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 23/06/15
  Time: 02:46 PM
--%>

<g:each in="${asignaciones}" var="asg">
    <tr data-res="${asg?.unidad?.id}" data-asi="${asg?.actividad}" data-par="${asg?.presupuesto?.descripcion}" data-parId="${asg?.presupuesto?.id}"  data-fue="${asg?.fuente?.id}" data-val="${asg?.planificado}" data-id="${asg?.id}">
        <td style="width: 300px">${asg?.actividad}</td>
        <td style="width: 300px;">${asg?.presupuesto?.numero + " "+ asg?.presupuesto?.descripcion}</td>
        <td style="width: 200px">${asg?.fuente?.descripcion}</td>
        <td style="width: 100px">${asg?.planificado}</td>
        <td>
            <div class="btn-group btn-group-xs" role="group">
                <a href="#" id="btnEditar" class="btn btn-success editar_ajax" title="Editar" iden="${asg.id}"><i class="fa fa-pencil"></i> </a>
                <a href="#" id="btnBorrar" class="btn btn-danger borrar_ajax" title="Borrar" iden="${asg.id}" nom="${asg?.actividad}"><i class="fa fa-trash"></i> </a>
            </div>
        </td>
    </tr>
</g:each>

<script>

    $(".borrar_ajax").click(function () {
        var idBorrar = $(this).attr("iden");
        var nombreBorrar = $(this).attr("nom")
        bootbox.confirm("<i class='fa fa-trash-o fa-3x pull-left text-danger text-shadow'></i>Está seguro que desea borrar la asignación: " + nombreBorrar + " ?" , function(result){
            if (result) {
                openLoader();
                $.ajax({
                    type   : "POST",
                    url    : "${createLink(controller:'asignacion', action:'delete_ajax')}?id=" + idBorrar,
                    success: function (msg) {
                        closeLoader();
                        var parts = msg.split("*");
                        log(parts[1], parts[0] == "SUCCESS" ? "success" : "error"); // log(msg, type, title, hide)
                        if (parts[0] == "SUCCESS") {
                            setTimeout(function() {
                                location.reload(true);
                            }, 1500);
                        }
                    }
                });
            }
        })
    });

    $(".editar_ajax").click(function () {
        var idEditar = $(this).attr("iden");
        $("#guardarEditar").addClass('show');
        $("#btnGuardar").addClass('hide');

        var responsableEditar = $(this).parents("tr").attr("data-res");
        var asignacionEditar = $(this).parents("tr").attr("data-asi");
        var fuenteEditar = $(this).parents("tr").attr("data-fue");
        var valorEditar = $(this).parents("tr").attr("data-val");
        var partidaEditar = $(this).parents("tr").attr("data-par");
        var partidaId = $(this).parents("tr").attr("data-parId");
        var asignacionId = $(this).parents("tr").attr("data-id");

//        console.log("datos " + $(this).parents("tr").attr("data-asi"))

        $("#responsable").val(responsableEditar);
        $("#asignacion_txt").val(asignacionEditar);
        $("#prsp_id").val(partidaId);
        $("#bsc-desc-prsp_id").val(partidaEditar);
        $("#valor").val(valorEditar);
        $("#fuente").val(fuenteEditar);
        $("#asignacionId").val(asignacionId);
    });

</script>

