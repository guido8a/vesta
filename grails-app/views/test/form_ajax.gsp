<%@ page import="vesta.test.Test" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!testInstance}">
    <elm:notFound elem="Test" genero="o" />
</g:if>
<g:else>
    
    <div class="modal-contenido">
    <g:form class="form-horizontal" name="frmTest" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${testInstance?.id}" />

        
        <div class="form-group keeptogether ${hasErrors(bean: testInstance, field: 'codigo', 'error')} required">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label">
                    Codigo
                </label>
                <div class="col-md-7">
                    <g:textField name="codigo" required="" class="form-control required unique noEspacios" value="${testInstance?.codigo}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: testInstance, field: 'email', 'error')} required">
            <span class="grupo">
                <label for="email" class="col-md-2 control-label">
                    Email
                </label>
                <div class="col-md-7">
                    <div class="input-group"><span class="input-group-addon"><i class="fa fa-envelope"></i></span><g:field type="email" name="email" required="" class="form-control required unique noEspacios" value="${testInstance?.email}"/></div>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: testInstance, field: 'existe', 'error')} ">
            <span class="grupo">
                <label for="existe" class="col-md-2 control-label">
                    Existe
                </label>
                <div class="col-md-7">
                    <g:checkBox name="existe" value="${testInstance?.existe}" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: testInstance, field: 'fecha', 'error')} required">
            <span class="grupo">
                <label for="fecha" class="col-md-2 control-label">
                    Fecha
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fecha"  class="datepicker form-control required" value="${testInstance?.fecha}"  />
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: testInstance, field: 'fechaHora', 'error')} required">
            <span class="grupo">
                <label for="fechaHora" class="col-md-2 control-label">
                    Fecha Hora
                </label>
                <div class="col-md-5">
                    <elm:datepicker name="fechaHora"  class="datepicker form-control required" value="${testInstance?.fechaHora}"  />
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: testInstance, field: 'login', 'error')} required">
            <span class="grupo">
                <label for="login" class="col-md-2 control-label">
                    Login
                </label>
                <div class="col-md-7">
                    <g:textField name="login" required="" class="form-control required unique noEspacios" value="${testInstance?.login}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: testInstance, field: 'mail', 'error')} required">
            <span class="grupo">
                <label for="mail" class="col-md-2 control-label">
                    Mail
                </label>
                <div class="col-md-7">
                    <div class="input-group"><span class="input-group-addon"><i class="fa fa-envelope"></i></span><g:field type="email" name="mail" required="" class="form-control required unique noEspacios" value="${testInstance?.mail}"/></div>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: testInstance, field: 'nombre', 'error')} required">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label">
                    Nombre
                </label>
                <div class="col-md-7">
                    <g:textField name="nombre" required="" class="form-control required" value="${testInstance?.nombre}"/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: testInstance, field: 'numeroDecimal', 'error')} required">
            <span class="grupo">
                <label for="numeroDecimal" class="col-md-2 control-label">
                    Numero Decimal
                </label>
                <div class="col-md-3">
                    <g:field name="numeroDecimal" type="number" value="${fieldValue(bean: testInstance, field: 'numeroDecimal')}" class="number form-control  required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: testInstance, field: 'numeroEntero', 'error')} required">
            <span class="grupo">
                <label for="numeroEntero" class="col-md-2 control-label">
                    Numero Entero
                </label>
                <div class="col-md-3">
                    <g:field name="numeroEntero" type="number" value="${testInstance.numeroEntero}" class="digits form-control required" required=""/>
                </div>
                 *
            </span>
        </div>
        
        <div class="form-group keeptogether ${hasErrors(bean: testInstance, field: 'password', 'error')} required">
            <span class="grupo">
                <label for="password" class="col-md-2 control-label">
                    Password
                </label>
                <div class="col-md-7">
                    <div class="input-group"><span class="input-group-addon"><i class="fa fa-lock"></i></span><g:field type="password" name="password" required="" class="form-control required" value="${testInstance?.password}"/></div>
                </div>
                 *
            </span>
        </div>
        
    </g:form>
        </div>

    <script type="text/javascript">
        var validator = $("#frmTest").validate({
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
                            id: "${testInstance?.id}"
                        }
                    }
                },
                
                email: {
                    remote: {
                        url: "${createLink(action: 'validar_unique_email_ajax')}",
                        type: "post",
                        data: {
                            id: "${testInstance?.id}"
                        }
                    }
                },
                
                login: {
                    remote: {
                        url: "${createLink(action: 'validar_unique_login_ajax')}",
                        type: "post",
                        data: {
                            id: "${testInstance?.id}"
                        }
                    }
                },
                
                mail: {
                    remote: {
                        url: "${createLink(action: 'validar_unique_mail_ajax')}",
                        type: "post",
                        data: {
                            id: "${testInstance?.id}"
                        }
                    }
                }
                
            },
            messages : {
                
                codigo: {
                    remote: "Ya existe Codigo"
                },
                
                email: {
                    remote: "Ya existe Email"
                },
                
                login: {
                    remote: "Ya existe Login"
                },
                
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