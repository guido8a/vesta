<%@ page import="vesta.proyectos.Documento" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!documentoInstance}">
    <elm:notFound elem="Documento" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:uploadForm class="form-horizontal" name="frmDocumento" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${documentoInstance?.id}"/>

            <div class="form-group keeptogether ${hasErrors(bean: documentoInstance, field: 'grupoProcesos', 'error')} ">
                <span class="grupo">
                    <label for="grupoProcesos" class="col-md-4 control-label">
                        Grupo de Procesos
                    </label>

                    <div class="col-md-6">
                        <g:select id="grupoProcesos" name="grupoProcesos.id" from="${vesta.parametros.proyectos.GrupoProcesos.list()}" optionKey="id" value="${documentoInstance?.grupoProcesos?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: documentoInstance, field: 'descripcion', 'error')} ">
                <span class="grupo">
                    <label for="descripcion" class="col-md-4 control-label">
                        Descripción
                    </label>

                    <div class="col-md-6">
                        <g:textField name="descripcion" maxlength="63" class="form-control input-sm" value="${documentoInstance?.descripcion}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: documentoInstance, field: 'clave', 'error')} ">
                <span class="grupo">
                    <label for="clave" class="col-md-4 control-label">
                        Palabras Clave
                    </label>

                    <div class="col-md-6">
                        <g:textField name="clave" maxlength="63" class="form-control input-sm" value="${documentoInstance?.clave}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: documentoInstance, field: 'resumen', 'error')} ">
                <span class="grupo">
                    <label for="resumen" class="col-md-4 control-label">
                        Resumen
                    </label>

                    <div class="col-md-6">
                        <g:textArea name="resumen" cols="40" rows="5" maxlength="1024" class="form-control input-sm" value="${documentoInstance?.resumen}"/>
                    </div>
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: documentoInstance, field: 'documento', 'error')} ">
                <span class="grupo">
                    <label for="documento" class="col-md-4 control-label">
                        Documento
                    </label>

                    <div class="col-md-6">
                        <input type="file" name="documento" class="form-control input-sm"/>
                    </div>

                </span>
            </div>
        </g:uploadForm>
    </div>

    <script type="text/javascript">
        var validator = $("#frmDocumento").validate({
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
                submitFormDocumento();
                return false;
            }
            return true;
        });
    </script>

</g:else>