<%@ page import="vesta.poaCorrientes.Tarea" %>
<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 08/07/15
  Time: 11:01 AM
--%>

<g:if test="${acts.size() > 0}">
    <g:each in="${acts}" var="act">
        <div class="actCopiada corner-all">
            <div class="actTitleCopiada corner-all" data-id="${act.id}">
                ${act.descripcion}

                <div class="divSelectAllCopiada">
                    <i class="fa fa-square-o"></i>
                </div>
            </div>

            <div class="tareasCopiada">
                <g:each in="${Tarea.findAllByActividad(act)}" var="tarea">
                    <div class="tareaCopiada corner-all" data-id="${tarea.id}">
                        ${tarea.descripcion}

                        <div class="divSelectCopiada">
                            <i class="fa fa-square-o"></i>
                        </div>
                    </div>
                </g:each>
            </div>
        </div>
    </g:each>

    <script type="text/javascript">

        function activarCopiadas($elm) {
//            console.log("activar", $elm);
            var $check = $elm.find("i");
            $elm.addClass("selected");
            $check.removeClass("fa-square-o").addClass("fa-check-square");
        }
        function desactivarCopiadas($elm) {
//            console.log("desactivar", $elm);
            var $check = $elm.find("i");
            $elm.removeClass("selected");
            $check.removeClass("fa-check-square").addClass("fa-square-o");
        }

        function toggleActividadTareasCopiadas($act) {
            if ($act.hasClass("selected")) {
                desactivarCopiadas($act);
                desactivarCopiadas($act.parents(".actCopiada").find(".tareaCopiada"));
            } else {
                activarCopiadas($act);
                activarCopiadas($act.parents(".actCopiada").find(".tareaCopiada"));
            }
            validarEliminar();
        }

        function toggleTareaCopiadas($tarea) {
            if ($tarea.hasClass("selected")) {
                desactivarCopiadas($tarea);
            } else {
                activarCopiadas($tarea);
//                var $act = $tarea.parents(".actCopiada").find(".actTitleCopiada");
//                activarCopiadas($act);
            }
            validarEliminar();
        }

        $(".actTitleCopiada").click(function () {
            var $this = $(this);
            toggleActividadTareasCopiadas($this);
        });
        $(".tareaCopiada").click(function () {
            var $this = $(this);
            toggleTareaCopiadas($this);
        });
    </script>

</g:if>
<g:else>
    <div class="act corner-all text-shadow text-center">
        <i class="fa icon-ghost fa-2x"></i> No se encontraron actividades ni tareas
    </div>
</g:else>