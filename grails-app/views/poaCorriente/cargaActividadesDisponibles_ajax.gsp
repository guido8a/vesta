<%@ page import="vesta.poaCorrientes.Tarea" %>
<%--
  Created by IntelliJ IDEA.
  User: luz
  Date: 03/07/15
  Time: 01:04 PM
--%>

<g:if test="${acts.size() > 0}">
    <g:each in="${acts}" var="act">
        <div class="actDisp corner-all">
            <div class="actTitleDisp corner-all" data-id="${act.id}">
                ${act.descripcion}

                <div class="divSelectAllDisp">
                    <i class="fa fa-square-o"></i>
                </div>
            </div>

            <div class="tareas">
                <g:each in="${Tarea.findAllByActividad(act)}" var="tarea">
                    <div class="tareaDisp corner-all" data-id="${tarea.id}">
                        ${tarea.descripcion}

                        <div class="divSelectDisp">
                            <i class="fa fa-square-o"></i>
                        </div>
                    </div>
                </g:each>
            </div>
        </div>
    </g:each>

    <script type="text/javascript">

        function activar($elm) {
//            console.log("activar", $elm);
            var $check = $elm.find("i");
            $elm.addClass("selected");
            $check.removeClass("fa-square-o").addClass("fa-check-square");
        }
        function desactivar($elm) {
//            console.log("desactivar", $elm);
            var $check = $elm.find("i");
            $elm.removeClass("selected");
            $check.removeClass("fa-check-square").addClass("fa-square-o");
        }

        function toggleActividadTareas($act) {
            if ($act.hasClass("selected")) {
                desactivar($act);
                desactivar($act.parents(".actDisp").find(".tareaDisp"));
            } else {
                activar($act);
                activar($act.parents(".actDisp").find(".tareaDisp"));
            }
            validarCopiar();
        }

        function toggleTarea($tarea) {
            if ($tarea.hasClass("selected")) {
                desactivar($tarea);
            } else {
                activar($tarea);
                var $act = $tarea.parents(".actDisp").find(".actTitleDisp");
                activar($act);
            }
            validarCopiar();
        }

        $(".actTitleDisp").click(function () {
            var $this = $(this);
            toggleActividadTareas($this);
        });
        $(".tareaDisp").click(function () {
            var $this = $(this);
            toggleTarea($this);
        });
    </script>

</g:if>
<g:else>
    <div class="act corner-all text-shadow text-center">
        <i class="fa icon-ghost fa-2x"></i> No se encontraron actividades ni tareas
    </div>
</g:else>