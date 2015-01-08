%{--<%@ page import="vesta.parametros.TipoInstitucion" %>--}%

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!actividadInstance}">
    <elm:notFound elem="Actividad" genero="o" />
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmNuevaActividad" role="form" action="newActividad_ajax" method="POST">
            <div class="form-group keeptogether ${hasErrors(bean: actividadInstance, field: 'proyecto', 'error')}">
                <span class="grupo">
                    <label for="proyecto.nombre" class="col-md-2 control-label">
                        Proyecto
                    </label>
                    <div class="col-md-6">
                        <g:hiddenField name="proyecto.id" value="${proyecto?.id}"/>
                        <g:textField name="proyecto.nombre" class="form-control input-sm" value="${proyecto?.nombre}" readonly=""/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: actividadInstance, field: 'componente', 'error')}">
                <span class="grupo">
                    <label for="componente.nombre" class="col-md-2 control-label">
                        Componente
                    </label>
                    <div class="col-md-6">
                        <g:hiddenField name="componente.id" value="${componente?.id}"/>
                        <g:textField name="componente.nombre" id="componenteLabel" class="form-control input-sm required" value="${componente}" readonly=""/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: actividadInstance, field: 'categoria', 'error')} required">
                <span class="grupo">
                    <label for="nuevaCategoria" class="col-md-2 control-label">
                        Categoría
                    </label>
                    <div class="col-md-6">
                        <g:select name="nuevaCategoria" from="${vesta.proyectos.Categoria.list()}" class="form-control input-sm" optionKey="id" optionValue="descripcion"/>
                    </div>
                    *
                </span>
            </div>


            <div class="form-group keeptogether ${hasErrors(bean: actividadInstance, field: 'objeto', 'error')} required">
                <span class="grupo">
                    <label for="nuevaActividad" class="col-md-2 control-label">
                        Actividad
                    </label>
                    <div class="col-md-6">
                        <g:textArea name="nuevaActividad" cols="4" rows="6" maxlength="1023" class="form-control input-sm required" style="resize: none"/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: actividadInstance, field: 'monto', 'error')} required">
                <span class="grupo">
                    <label for="nuevoMonto" class="col-md-2 control-label">
                        Monto
                    </label>
                    <div class="col-md-6">
                        <g:textField name="nuevoMonto" maxlength="31" class="form-control input-sm required number money"/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: actividadInstance, field: 'fechaInicio', 'error')} required">
                <span class="grupo">
                    <label for="fechaInicio" class="col-md-2 control-label">
                        Fecha Inicio
                    </label>
                    <div class="col-md-6">
                        <elm:datepicker name="fechaInicio"  class="datepicker form-control required input-sm" value="${new Date()}"/>
                    </div>
                </span>
                *
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: actividadInstance, field: 'fechaFin', 'error')} required">
                <span class="grupo">
                    <label for="fechaFin" class="col-md-2 control-label">
                        Fecha Fin
                    </label>
                    <div class="col-md-6">
                        <elm:datepicker name="fechaFin"  class="datepicker form-control required input-sm" value="${new Date()}"/>
                    </div>
                </span>
                *
            </div>
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmNuevaActividad").validate({
            errorClass     : "help-block",
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
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitForm();
                return false;
            }
            return true;
        });





    </script>

</g:else>