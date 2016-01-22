<%@ page import="vesta.parametros.UnidadEjecutora; vesta.proyectos.Categoria; vesta.proyectos.MarcoLogico" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!marcoLogicoInstance}">
    <elm:notFound elem="MarcoLogico" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">

        <g:form class="form-horizontal" name="frmaActividad" role="form" action="cambiaNumeroActividad" method="POST">
            <g:hiddenField name="id" value="${marcoLogicoInstance?.id}"/>

%{--
            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'responsable', 'error')} ">
                <span class="grupo">
                    <label for="responsable" class="col-md-2 control-label">
                        Responsable
                    </label>

                    <div class="col-md-7">
                        <g:select id="responsable" name="responsable.id" from="${UnidadEjecutora.list([sort: 'nombre'])}"
                                  optionKey="id" value="${marcoLogicoInstance?.responsable?.id}"
                                  class="many-to-one form-control input-sm required" noSelection="['': '']"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'categoria', 'error')} ">
                <span class="grupo">
                    <label for="categoria" class="col-md-2 control-label">
                        Categoría
                    </label>

                    <div class="col-md-7">
                        <g:select id="categoria" name="categoria.id" from="${Categoria.list([sort: 'descripcion'])}"
                                  optionKey="id" optionValue="descripcion"
                                  value="${marcoLogicoInstance?.categoria?.id}"
                                  class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'objeto', 'error')} ">
                <span class="grupo">
                    <label for="objeto" class="col-md-2 control-label">
                        Actividad
                    </label>

                    <div class="col-md-10">
                        <g:textArea name="objeto" cols="40" rows="5" maxlength="1023" class="form-control input-sm required"
                                    value="${marcoLogicoInstance?.objeto}"/>
                    </div>
                </span>
            </div>
--}%

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'fechaInicio', 'error')} ">
                <span class="grupo">
                    <label for="numero" class="col-md-4 control-label">
                        Número de actividad
                    </label>

                    <div class="col-md-2">
                        <g:textField name="numero" value="${marcoLogicoInstance.numero}"
                                     class="number form-control input-sm " />

                    </div>
                </span>
            </div>

        </g:form>
    </div>
    <script type="text/javascript">
        var validator = $("#frmActividad").validate({
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
                label.remove();
            }

        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormActividad("${show}");
                return false;
            }
            return true;
        });
    </script>
</g:else>