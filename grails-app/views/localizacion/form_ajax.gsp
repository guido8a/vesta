<%@ page import="vesta.parametros.Localizacion" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!localizacionInstance}">
    <elm:notFound elem="Localizacion" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmLocalizacion" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${localizacionInstance?.id}"/>


            <div class="form-group keeptogether ${hasErrors(bean: localizacionInstance, field: 'codigo', 'error')} required">
                <span class="grupo">
                    <label for="codigo" class="col-md-2 control-label">
                        Código
                    </label>

                    <div class="col-md-6">
                        <g:textField name="codigo" maxlength="4" required="" class="form-control input-sm required unique noEspacios" value="${localizacionInstance?.codigo}"/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: localizacionInstance, field: 'descripcion', 'error')} required">
                <span class="grupo">
                    <label for="descripcion" class="col-md-2 control-label">
                        Descripción
                    </label>

                    <div class="col-md-6">
                        <g:textArea name="descripcion" cols="40" rows="5" maxlength="511" required="" class="form-control input-sm required" value="${localizacionInstance?.descripcion}"/>
                    </div>
                    *
                </span>
            </div>

        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmLocalizacion").validate({
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

            , rules  : {

                codigo : {
                    remote : {
                        url  : "${createLink(action: 'validar_unique_codigo_ajax')}",
                        type : "post",
                        data : {
                            id : "${localizacionInstance?.id}"
                        }
                    }
                }

            },
            messages : {

                codigo : {
                    remote : "Ya existe Código"
                }

            }

        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormLocalizacion();
                return false;
            }
            return true;
        });
    </script>

</g:else>