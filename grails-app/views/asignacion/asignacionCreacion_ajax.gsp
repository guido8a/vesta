<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 01/07/15
  Time: 11:54 AM
--%>

<table class="table table-condensed table-bordered table-striped table-hover" style="width: auto;">
  <thead>
  <th style="width: 200px">Responsable</th>
  <th style="width: 220px">Asignación</th>
  <th style="width: 210px;">Partida</th>
  <th style="width: 150px;">Fuente</th>
  <th style="width: 100px;">Presupuesto</th>
  <th style="width: 100px;"></th>
  </thead>
  <tbody>

  <tr class="odd">
    <g:hiddenField name="asignacionId" value=""/>
    <td>
      <g:select name="responsable" from="${vesta.parametros.UnidadEjecutora.list()}" optionKey="id" optionValue="nombre" style="width: 200px" class="many-to-one form-control input-sm"/>
    </td>
    <td class="actividad">
      %{--<g:textField name="asignacion_name" style="width: 220px; height: 40px" id="asignacion_txt" maxlength="100" class="form-control input-sm"/>--}%

      <g:textArea name="asignacion_name" style="width: 220px;height: 40px" id="asignacion_txt" maxlength="200px" class="form-control input-sm"/>
    </td>

    <td class="prsp">
      <bsc:buscador name="partida" id="prsp_id" controlador="asignacion" accion="buscarPresupuesto" tipo="search"
                    titulo="Busque una partida" campos="${campos}" clase="required" style="width:100%;"/>
    </td>
    <td class="fuente">
      <g:select from="${fuentes}" id="fuente" optionKey="id" optionValue="descripcion" name="fuente" class="fuente many-to-one form-control input-sm" value="" style="width: 150px;"/>
    </td>

    <td class="valor">
      <g:textField name="valor_name" id="valor" class="form-control input-sm number money" style="width: 100px" value=""/>

    </td>
    <td>
      <a href="#" id="btnGuardar" class="btn btn-sm btn-success"><i class="fa fa-plus"></i> Agregar</a>
      <div class="btn-group btn-group-xs" role="group" style="width: 100px;">
        <a href="#" id="guardarEditar" class="btn btn-success hide" title="Guardar"><i class="fa fa-save"></i></a>
        <a href="#" id="cancelarEditar" class="btn btn-danger hide" title="Cancelar edición"><i class="fa fa-remove"></i>Cancelar</a>
      </div>

    </td>
  </tr>

  </tbody>
</table>

<script type="text/javascript">

  $("#guardarEditar").click (function () {

    var responsable = $("#responsable").val();
    var asignacion = $("#asignacion_txt").val();
    var parti = $("#prsp_id").val();
    var fuente = $("#fuente").val();
    var valor = $("#valor").val();
    var asigId = $("#asignacionId").val();

    if(asignacion != ''){
      if(parti != null && parti != 'null'){
        if(fuente != null){
          if(valor != ''){
            $.ajax({
              type:"POST",
              url:"${createLink(action:'guardarAsignacion',controller:'asignacion')}",
              data:"&responsable=" + responsable +"&asignacion=" + asignacion + "&partida=" + parti + "&fuente=" + fuente + "&valor=" + valor + "&id=" + asigId,
              success:function (msg) {
                var parts = msg.split("*");
                log(parts[1], parts[0] == "SUCCESS" ? "success" : "error");
                if (parts[0] == "SUCCESS") {
                  setTimeout(function() {
                    location.reload(true);
                  }, 1500);
                }
              }
            });
          }else{
            log("Debe ingresar un valor", "error")
          }
        }else{
          log("Debe seleccionar una fuente", "error")
        }
      }else{
        log("Debe seleccionar una partida", "error")
      }
    }else{
      log("Ingrese el nombre de la asignación", "error")
    }

  });


$("#cancelarEditar").click(function () {
    $(this).replaceWith(spinner);
    location.href="${createLink(controller: "asignacion", action: "asignacionesCorrientesv2")}";
        });
</script>