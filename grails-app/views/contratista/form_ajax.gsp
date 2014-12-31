<%@ page import="vesta.parametros.Contratista" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!contratistaInstance}">
    <elm:notFound elem="Contratista" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmContratista" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${contratistaInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: contratistaInstance, field: 'ruc', 'error')} required">
            <span class="grupo">
                <label for="ruc" class="col-md-2 control-label">
                    Ruc
                </label>
                <div class="col-md-7">
                    <g:textField name="ruc" maxlength="13" required="" class="form-control input-sm required" value="${contratistaInstance?.ruc}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: contratistaInstance, field: 'direccion', 'error')} ">
            <span class="grupo">
                <label for="direccion" class="col-md-2 control-label">
                    Direccion
                </label>
                <div class="col-md-7">
                    <g:textArea name="direccion" cols="40" rows="5" maxlength="255" class="form-control input-sm" value="${contratistaInstance?.direccion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: contratistaInstance, field: 'fecha', 'error')} ">
            <span class="grupo">
                <label for="fecha" class="col-md-2 control-label">
                    Fecha
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fecha" mensaje="Fecha"  class="datepicker form-control input-sm" value="${contratistaInstance?.fecha}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: contratistaInstance, field: 'nombreCont', 'error')} ">
            <span class="grupo">
                <label for="nombreCont" class="col-md-2 control-label">
                    Nombre Cont
                </label>
                <div class="col-md-7">
                    <g:textField name="nombreCont" maxlength="63" class="form-control input-sm" value="${contratistaInstance?.nombreCont}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: contratistaInstance, field: 'nombre', 'error')} required">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label">
                    Nombre
                </label>
                <div class="col-md-7">
                    <g:textField name="nombre" maxlength="63" required="" class="form-control input-sm required" value="${contratistaInstance?.nombre}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: contratistaInstance, field: 'apellido', 'error')} ">
            <span class="grupo">
                <label for="apellido" class="col-md-2 control-label">
                    Apellido
                </label>
                <div class="col-md-7">
                    <g:textField name="apellido" maxlength="63" class="form-control input-sm" value="${contratistaInstance?.apellido}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: contratistaInstance, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="observaciones" class="col-md-2 control-label">
                    Observaciones
                </label>
                <div class="col-md-7">
                    <g:textArea name="observaciones" cols="40" rows="5" maxlength="255" class="form-control input-sm" value="${contratistaInstance?.observaciones}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: contratistaInstance, field: 'telefono', 'error')} ">
            <span class="grupo">
                <label for="telefono" class="col-md-2 control-label">
                    Telefono
                </label>
                <div class="col-md-7">
                    <g:textField name="telefono" maxlength="40" class="form-control input-sm" value="${contratistaInstance?.telefono}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: contratistaInstance, field: 'mail', 'error')} ">
            <span class="grupo">
                <label for="mail" class="col-md-2 control-label">
                    Mail
                </label>
                <div class="col-md-7">
                    <div class="input-group input-group-sm"><span class="input-group-addon"><i class="fa fa-envelope"></i></span><g:field type="email" name="mail" maxlength="40" class="form-control input-sm unique noEspacios" value="${contratistaInstance?.mail}"/></div>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: contratistaInstance, field: 'estado', 'error')} ">
            <span class="grupo">
                <label for="estado" class="col-md-2 control-label">
                    Estado
                </label>
                <div class="col-md-7">
                    <g:textField name="estado" class="form-control input-sm" value="${contratistaInstance?.estado}"/>
                </div>
                
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmContratista").validate({
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
                
                mail: {
                    remote: {
                        url: "${createLink(action: 'validar_unique_mail_ajax')}",
                        type: "post",
                        data: {
                            id: "${contratistaInstance?.id}"
                        }
                    }
                }
                
            },
            messages : {
                
                mail: {
                    remote: "Ya existe Mail"
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