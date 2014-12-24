<%@ page import="vesta.parametros.Entidad" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!entidadInstance}">
    <elm:notFound elem="Entidad" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmEntidad" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${entidadInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: entidadInstance, field: 'nombre', 'error')} required">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label">
                    Nombre
                </label>
                <div class="col-md-6">
                    <g:textField name="nombre" maxlength="63" required="" class="form-control input-sm required" value="${entidadInstance?.nombre}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: entidadInstance, field: 'direccion', 'error')} ">
            <span class="grupo">
                <label for="direccion" class="col-md-2 control-label">
                    Direccion
                </label>
                <div class="col-md-6">
                    <g:textField name="direccion" maxlength="127" class="form-control input-sm" value="${entidadInstance?.direccion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: entidadInstance, field: 'sigla', 'error')} ">
            <span class="grupo">
                <label for="sigla" class="col-md-2 control-label">
                    Sigla
                </label>
                <div class="col-md-6">
                    <g:textField name="sigla" maxlength="7" class="form-control input-sm" value="${entidadInstance?.sigla}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: entidadInstance, field: 'objetivo', 'error')} ">
            <span class="grupo">
                <label for="objetivo" class="col-md-2 control-label">
                    Objetivo
                </label>
                <div class="col-md-6">
                    <g:textField name="objetivo" maxlength="63" class="form-control input-sm" value="${entidadInstance?.objetivo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: entidadInstance, field: 'telefono', 'error')} ">
            <span class="grupo">
                <label for="telefono" class="col-md-2 control-label">
                    Telefono
                </label>
                <div class="col-md-6">
                    <g:textField name="telefono" maxlength="63" class="form-control input-sm" value="${entidadInstance?.telefono}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: entidadInstance, field: 'fax', 'error')} ">
            <span class="grupo">
                <label for="fax" class="col-md-2 control-label">
                    Fax
                </label>
                <div class="col-md-6">
                    <g:textField name="fax" maxlength="63" class="form-control input-sm" value="${entidadInstance?.fax}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: entidadInstance, field: 'email', 'error')} ">
            <span class="grupo">
                <label for="email" class="col-md-2 control-label">
                    Email
                </label>
                <div class="col-md-6">
                    <div class="input-group"><span class="input-group-addon"><i class="fa fa-envelope"></i></span><g:field type="email" name="email" maxlength="63" class="form-control input-sm unique noEspacios" value="${entidadInstance?.email}"/></div>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: entidadInstance, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="observaciones" class="col-md-2 control-label">
                    Observaciones
                </label>
                <div class="col-md-6">
                    <g:textField name="observaciones" maxlength="127" class="form-control input-sm" value="${entidadInstance?.observaciones}"/>
                </div>
                
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmEntidad").validate({
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
                
                email: {
                    remote: {
                        url: "${createLink(action: 'validar_unique_email_ajax')}",
                        type: "post",
                        data: {
                            id: "${entidadInstance?.id}"
                        }
                    }
                }
                
            },
            messages : {
                
                email: {
                    remote: "Ya existe Email"
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