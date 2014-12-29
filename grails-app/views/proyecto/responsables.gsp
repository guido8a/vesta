<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 9/12/11
  Time: 12:50 PM
  To change this template use File | Settings | File Templates.
--%>

<div id="tabs">
    <ul>
        <li id="li_actuales">
            <a href="${createLink(action: 'responsable', id: proyecto.id)}" id="a_actuales" title="actuales">Actuales</a>
        </li>
        <li id="li_historial">
            <a href="${createLink(action: 'historialResponsables', id: proyecto.id)}" id="a_historial" title="historial">Historial</a>
        </li>
    </ul>
</div>

<script>
    $(function() {
        $("#tabs").tabs({
            ajaxOptions: {
                error: function(xhr, status, index, anchor) {
                    $(anchor.hash).html(
                            "No se ha podido cargar el contenido solicitado");
                }
            }
        });
    });
</script>