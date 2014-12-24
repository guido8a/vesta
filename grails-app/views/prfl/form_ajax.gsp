<%@ page import="vesta.seguridad.Prfl" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!prflInstance}">
    <elm:notFound elem="Prfl" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmPrfl" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${prflInstance?.id}"/>

            <div class="form-group keeptogether ${hasErrors(bean: prflInstance, field: 'descripcion', 'error')} required">
                <span class="grupo">
                    <label for="descripcion" class="col-md-2 control-label">
                        Descripción
                    </label>

                    <div class="col-md-6">
                        <g:textField name="descripcion" required="" class="form-control input-sm required" value="${prflInstance?.descripcion}"/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: prflInstance, field: 'nombre', 'error')} required">
                <span class="grupo">
                    <label for="nombre" class="col-md-2 control-label">
                        Nombre
                    </label>

                    <div class="col-md-6">
                        <g:textField name="nombre" required="" class="form-control input-sm required" value="${prflInstance?.nombre}"/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: prflInstance, field: 'codigo', 'error')} ">
                <span class="grupo">
                    <label for="codigo" class="col-md-2 control-label">
                        Código
                    </label>

                    <div class="col-md-6">
                        <g:textField name="codigo" class="form-control input-sm unique noEspacios" value="${prflInstance?.codigo}"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: prflInstance, field: 'observaciones', 'error')} required">
                <span class="grupo">
                    <label for="observaciones" class="col-md-2 control-label">
                        Observaciones
                    </label>

                    <div class="col-md-6">
                        <g:textField name="observaciones" required="" class="form-control input-sm required" value="${prflInstance?.observaciones}"/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: prflInstance, field: 'padre', 'error')} required">
                <span class="grupo">
                    <label for="padre" class="col-md-2 control-label">
                        Padre
                    </label>

                    <div class="col-md-6">
                        <g:select id="padre" name="padre.id" from="${Prfl.list()}" optionKey="id" required="" value="${prflInstance?.padre?.id}" class="many-to-one form-control input-sm"/>
                    </div>
                    *
                </span>
            </div>
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmPrfl").validate({
            errorClass    : "help-block",
            errorPlacement: function (error, element) {
                if (element.parent().hasClass("input-group")) {
                    error.insertAfter(element.parent());
                } else {
                    error.insertAfter(element);
                }
                element.parents(".grupo").addClass('has-error');
            },
            success       : function (label) {
                label.parents(".grupo").removeClass('has-error');
            }

            , rules       : {

                codigo: {
                    remote: {
                        url : "${createLink(action: 'validar_unique_codigo_ajax')}",
                        type: "post",
                        data: {
                            id: "${prflInstance?.id}"
                        }
                    }
                }

            },
            messages      : {

                codigo: {
                    remote: "Ya existe Codigo"
                }

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