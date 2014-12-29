<%@ page import="vesta.parametros.CargoPersonal" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!cargoPersonalInstance}">
    <elm:notFound elem="CargoPersonal" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmCargoPersonal" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${cargoPersonalInstance?.id}" />
        <g:if test="${band == 1}">
            <div class="form-group keeptogether ${hasErrors(bean: cargoPersonalInstance, field: 'codigo', 'error')} ">
                <span class="grupo">
                    <label for="codigo" class="col-md-2 control-label">
                        Código
                    </label>
                    <div class="col-md-6">
                        <g:textField name="codigo" maxlength="4" style="width: 100px;" class="form-control input-sm unique noEspacios text-uppercase"  value="${cargoPersonalInstance?.codigo}"/>
                    </div>

                </span>
            </div>
        </g:if>
        <g:else>
            <div class="form-group keeptogether ${hasErrors(bean: cargoPersonalInstance, field: 'codigo', 'error')} ">
                <span class="grupo">
                    <label for="codigo" class="col-md-2 control-label">
                        Código
                    </label>
                    <div class="col-md-6">
                        <g:textField name="codigo" maxlength="4" style="width: 100px" class="form-control input-sm unique noEspacios"  disabled="disabled" value="${cargoPersonalInstance?.codigo}"/>
                    </div>

                </span>
            </div>
        </g:else>
        <div class="form-group keeptogether ${hasErrors(bean: cargoPersonalInstance, field: 'descripcion', 'error')} required">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label">
                    Descripción
                </label>
                <div class="col-md-8">
                    <g:textField name="descripcion" style="width: 350px" maxlength="63" pattern="${cargoPersonalInstance.constraints.descripcion.matches}" required="" class="form-control input-sm required" value="${cargoPersonalInstance?.descripcion}"/>
                </div>
                *
            </span>
        </div>

        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmCargoPersonal").validate({
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
            
            , rules          : {
                
                codigo: {
                    remote: {
                        url: "${createLink(action: 'validar_unique_codigo_ajax')}",
                        type: "post",
                        data: {
                            id: "${cargoPersonalInstance?.id}"
                        }
                    }
                }
                
            },
            messages : {
                
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