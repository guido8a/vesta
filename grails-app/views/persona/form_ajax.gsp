<%@ page import="vesta.seguridad.Persona" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!personaInstance}">
    <elm:notFound elem="Persona" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmPersona" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${personaInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'cedula', 'error')} required">
            <span class="grupo">
                <label for="cedula" class="col-md-2 control-label">
                    Cedula
                </label>
                <div class="col-md-7">
                    <g:textField name="cedula" maxlength="13" pattern="${personaInstance.constraints.cedula.matches}" required="" class="form-control required" value="${personaInstance?.cedula}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'nombre', 'error')} required">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label">
                    Nombre
                </label>
                <div class="col-md-7">
                    <g:textField name="nombre" maxlength="40" pattern="${personaInstance.constraints.nombre.matches}" required="" class="form-control required" value="${personaInstance?.nombre}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'apellido', 'error')} required">
            <span class="grupo">
                <label for="apellido" class="col-md-2 control-label">
                    Apellido
                </label>
                <div class="col-md-7">
                    <g:textField name="apellido" maxlength="40" pattern="${personaInstance.constraints.apellido.matches}" required="" class="form-control required" value="${personaInstance?.apellido}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'sexo', 'error')} required">
            <span class="grupo">
                <label for="sexo" class="col-md-2 control-label">
                    Sexo
                </label>
                <div class="col-md-7">
                    <g:select name="sexo" from="${personaInstance.constraints.sexo.inList}" required="" class="form-control required" value="${personaInstance?.sexo}" valueMessagePrefix="persona.sexo"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'discapacitado', 'error')} ">
            <span class="grupo">
                <label for="discapacitado" class="col-md-2 control-label">
                    Discapacitado
                </label>
                <div class="col-md-7">
                    <g:textField name="discapacitado" maxlength="1" pattern="${personaInstance.constraints.discapacitado.matches}" class="form-control" value="${personaInstance?.discapacitado}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'fechaNacimiento', 'error')} ">
            <span class="grupo">
                <label for="fechaNacimiento" class="col-md-2 control-label">
                    Fecha Nacimiento
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaNacimiento" mensaje="Fecha de nacimiento de la persona"  class="datepicker form-control" value="${personaInstance?.fechaNacimiento}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'direccion', 'error')} ">
            <span class="grupo">
                <label for="direccion" class="col-md-2 control-label">
                    Direccion
                </label>
                <div class="col-md-7">
                    <g:textField name="direccion" maxlength="127" pattern="${personaInstance.constraints.direccion.matches}" class="form-control" value="${personaInstance?.direccion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'telefono', 'error')} ">
            <span class="grupo">
                <label for="telefono" class="col-md-2 control-label">
                    Telefono
                </label>
                <div class="col-md-7">
                    <g:textField name="telefono" maxlength="10" class="form-control" value="${personaInstance?.telefono}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'mail', 'error')} ">
            <span class="grupo">
                <label for="mail" class="col-md-2 control-label">
                    Mail
                </label>
                <div class="col-md-7">
                    <div class="input-group"><span class="input-group-addon"><i class="fa fa-envelope"></i></span><g:field type="email" name="mail" maxlength="40" class="form-control unique noEspacios" value="${personaInstance?.mail}"/></div>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'fax', 'error')} ">
            <span class="grupo">
                <label for="fax" class="col-md-2 control-label">
                    Fax
                </label>
                <div class="col-md-7">
                    <g:textField name="fax" maxlength="40" class="form-control" value="${personaInstance?.fax}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'observaciones', 'error')} ">
            <span class="grupo">
                <label for="observaciones" class="col-md-2 control-label">
                    Observaciones
                </label>
                <div class="col-md-7">
                    <g:textField name="observaciones" maxlength="127" pattern="${personaInstance.constraints.observaciones.matches}" class="form-control" value="${personaInstance?.observaciones}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'cargoPersonal', 'error')} ">
            <span class="grupo">
                <label for="cargoPersonal" class="col-md-2 control-label">
                    Cargo Personal
                </label>
                <div class="col-md-7">
                    <g:select id="cargoPersonal" name="cargoPersonal.id" from="${vesta.parametros.CargoPersonal.list()}" optionKey="id" value="${personaInstance?.cargoPersonal?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'login', 'error')} ">
            <span class="grupo">
                <label for="login" class="col-md-2 control-label">
                    Login
                </label>
                <div class="col-md-7">
                    <g:textField name="login" maxlength="15" pattern="${personaInstance.constraints.login.matches}" class="form-control unique noEspacios" value="${personaInstance?.login}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'password', 'error')} ">
            <span class="grupo">
                <label for="password" class="col-md-2 control-label">
                    Password
                </label>
                <div class="col-md-7">
                    <div class="input-group"><span class="input-group-addon"><i class="fa fa-lock"></i></span><g:field type="password" name="password" maxlength="64" pattern="${personaInstance.constraints.password.matches}" class="form-control" value="${personaInstance?.password}"/></div>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'autorizacion', 'error')} ">
            <span class="grupo">
                <label for="autorizacion" class="col-md-2 control-label">
                    Autorizacion
                </label>
                <div class="col-md-7">
                    <g:textArea name="autorizacion" cols="40" rows="5" maxlength="255" class="form-control" value="${personaInstance?.autorizacion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'sigla', 'error')} ">
            <span class="grupo">
                <label for="sigla" class="col-md-2 control-label">
                    Sigla
                </label>
                <div class="col-md-7">
                    <g:textField name="sigla" maxlength="8" pattern="${personaInstance.constraints.sigla.matches}" class="form-control" value="${personaInstance?.sigla}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'estaActivo', 'error')} required">
            <span class="grupo">
                <label for="estaActivo" class="col-md-2 control-label">
                    Esta Activo
                </label>
                <div class="col-md-3">
                    <g:field name="estaActivo" type="number" value="${personaInstance.estaActivo}" class="digits form-control required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'fechaPass', 'error')} ">
            <span class="grupo">
                <label for="fechaPass" class="col-md-2 control-label">
                    Fecha Pass
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaPass" mensaje="Fecha de cambio de contraseña"  class="datepicker form-control" value="${personaInstance?.fechaPass}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'unidad', 'error')} ">
            <span class="grupo">
                <label for="unidad" class="col-md-2 control-label">
                    Unidad
                </label>
                <div class="col-md-7">
                    <g:select id="unidad" name="unidad.id" from="${vesta.parametros.UnidadEjecutora.list()}" optionKey="id" value="${personaInstance?.unidad?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmPersona").validate({
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
                            id: "${personaInstance?.id}"
                        }
                    }
                },
                
                login: {
                    remote: {
                        url: "${createLink(action: 'validar_unique_login_ajax')}",
                        type: "post",
                        data: {
                            id: "${personaInstance?.id}"
                        }
                    }
                }
                
            },
            messages : {
                
                mail: {
                    remote: "Ya existe Mail"
                },
                
                login: {
                    remote: "Ya existe Login"
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