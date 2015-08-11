<%@ page import="vesta.parametros.UnidadEjecutora; vesta.seguridad.Prfl; vesta.seguridad.Persona" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!personaInstance}">
    <elm:notFound elem="Persona" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmPersona" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${personaInstance?.id}"/>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'cedula', 'error')} ${hasErrors(bean: personaInstance, field: 'sexo', 'error')} required">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="cedula" class="col-md-4 control-label">
                            Cédula
                        </label>

                        <div class="col-md-8">
                            <g:textField name="cedula" maxlength="13" pattern="${personaInstance.constraints.cedula.matches}" required="" class="form-control input-sm required" value="${personaInstance?.cedula}"/>
                        </div>
                    </span>
                </div>

                <div class="col-md-6">
                    <span class="grupo">
                        <label for="sexo" class="col-md-4 control-label">
                            Sexo
                        </label>

                        <div class="col-md-5">
                            <g:select name="sexo" from="${['F': 'Femenino', 'M': 'Masculino']}" required="" optionKey="key" optionValue="value"
                                      class="form-control input-sm required" value="${personaInstance?.sexo}"/>
                        </div>
                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'nombre', 'error')} ${hasErrors(bean: personaInstance, field: 'apellido', 'error')} required">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="nombre" class="col-md-4 control-label">
                            Nombre
                        </label>

                        <div class="col-md-8">
                            <g:textField name="nombre" maxlength="40" pattern="${personaInstance.constraints.nombre.matches}" required="" class="form-control input-sm required" value="${personaInstance?.nombre}"/>
                        </div>
                    </span>
                </div>

                <div class="col-md-6">
                    <span class="grupo">
                        <label for="apellido" class="col-md-4 control-label">
                            Apellido
                        </label>

                        <div class="col-md-8">
                            <g:textField name="apellido" maxlength="40" pattern="${personaInstance.constraints.apellido.matches}" required="" class="form-control input-sm required" value="${personaInstance?.apellido}"/>
                        </div>
                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'mail', 'error')} ${hasErrors(bean: personaInstance, field: 'telefono', 'error')} ">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="mail" class="col-md-4 control-label">
                            E-mail
                        </label>

                        <div class="col-md-8">
                            <div class="input-group input-group-sm"><span class="input-group-addon"><i class="fa fa-envelope"></i>
                            </span><g:field type="email" name="mail" maxlength="40" class="form-control input-sm unique noEspacios" value="${personaInstance?.mail}"/>
                            </div>
                        </div>
                    </span>
                </div>

                <div class="col-md-6">
                    <span class="grupo">
                        <label for="telefono" class="col-md-4 control-label">
                            Teléfono
                        </label>

                        <div class="col-md-8">
                            <g:textField name="telefono" maxlength="10" class="form-control input-sm" value="${personaInstance?.telefono}"/>
                        </div>

                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'direccion', 'error')} ">
                <div class="col-md-12">
                    <span class="grupo">
                        <label for="direccion" class="col-md-2 control-label">
                            Dirección
                        </label>

                        <div class="col-md-10">
                            <g:textArea name="direccion" cols="80" rows="1" maxlength="127"  pattern="${personaInstance.constraints.direccion.matches}" class="form-control input-sm" value="${personaInstance?.direccion}" style="resize: none"/>                        </div>

                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'unidad', 'error')} ${hasErrors(bean: personaInstance, field: 'cargoPersonal', 'error')}">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="unidad" class="col-md-4 control-label">
                            Unidad
                        </label>

                        <div class="col-md-8">
                            <g:select id="unidad" name="unidad.id" from="${UnidadEjecutora.list([sort:'nombre'])}" optionKey="id" value="${personaInstance?.unidad?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                        </div>

                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'cargo', 'error')} ">

                <div class="col-md-12 ">
                    <span class="grupo">
                        <label for="cargo" class="col-md-2 control-label">
                            Cargo
                        </label>


                        <div class="col-md-10">
                            <g:textArea name="cargo" cols="80" rows="1" maxlength="250" class="form-control input-sm" value="${personaInstance?.cargo}" style="resize: none"/>
                        </div>

                        %{--<div class="col-md-8">--}%
                        %{--<g:select id="cargoPersonal" name="cargoPersonal.id" from="${vesta.parametros.CargoPersonal.list()}" optionKey="id" value="${personaInstance?.cargoPersonal?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>--}%
                        %{--</div>--}%

                    </span>
                </div>
            </div>


            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'login', 'error')} ${hasErrors(bean: personaInstance, field: 'sigla', 'error')}">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="login" class="col-md-4 control-label">
                            Usuario
                        </label>

                        <div class="col-md-8">
                            <g:textField name="login" maxlength="15" pattern="${personaInstance.constraints.login.matches}" class="form-control input-sm unique noEspacios" value="${personaInstance?.login}"/>
                        </div>

                    </span>
                </div>

                <div class="col-md-6">
                    <span class="grupo">
                        <label for="sigla" class="col-md-4 control-label">
                            Sigla
                        </label>

                        <div class="col-md-3">
                            <g:textField name="sigla" maxlength="8" pattern="${personaInstance.constraints.sigla.matches}" class="form-control input-sm" value="${personaInstance?.sigla}"/>
                        </div>

                    </span>
                </div>

            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'estaActivo', 'error')} ${hasErrors(bean: personaInstance, field: 'fechaPass', 'error')} required">
                <div class="col-md-6">
                    <span class="grupo">
                        <label for="estaActivo" class="col-md-4 control-label">
                            Activo
                        </label>

                        <div class="col-md-3">
                            <g:select name="estaActivo" value="${personaInstance.estaActivo}" class="form-control input-sm required" required=""
                                      from="${[1: 'Sí', 0: 'No']}" optionKey="key" optionValue="value"/>
                        </div>
                    </span>
                </div>

            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'observaciones', 'error')} ">
                <div class="col-md-12">
                    <span class="grupo">
                        <label for="observaciones" class="col-md-2 control-label">
                            Observaciones
                        </label>

                        <div class="col-md-10">
                            <g:textField name="observaciones" maxlength="127" pattern="${personaInstance.constraints.observaciones.matches}" class="form-control input-sm" value="${personaInstance?.observaciones}"/>
                        </div>

                    </span>
                </div>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: personaInstance, field: 'observaciones', 'error')} ">
                <div class="col-md-12">
                    <span class="grupo">
                        <label for="observaciones" class="col-md-2 control-label">
                            Perfiles
                        </label>

                        <div class="col-md-10">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="col-md-10">
                                        <g:select name="perfil" from="${Prfl.list([sort: 'nombre'])}" class="form-control input-sm"
                                                  optionKey="id" optionValue="nombre"/>
                                    </div>

                                    <div class="col-md-2">
                                        <a href="#" class="btn btn-success btn-sm" id="btn-addPerfil" title="Agregar perfil">
                                            <i class="fa fa-plus"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <table id="tblPerfiles" class="table table-hover table-bordered table-condensed">
                                        <g:each in="${perfiles.perfil}" var="perfil">
                                            <tr class="perfiles" data-id="${perfil.id}">
                                                <td>
                                                    ${perfil.nombre}
                                                </td>
                                                <td width="35">
                                                    <a href="#" class="btn btn-danger btn-xs btn-deletePerfil">
                                                        <i class="fa fa-trash-o"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </g:each>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </span>
                </div>
            </div>
        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmPersona").validate({
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
label.remove();
            },
            rules         : {
                mail : {
                    remote: {
                        url : "${createLink(action: 'validar_unique_mail_ajax')}",
                        type: "post",
                        data: {
                            id: "${personaInstance?.id}"
                        }
                    }
                },
                login: {
                    remote: {
                        url : "${createLink(action: 'validar_unique_login_ajax')}",
                        type: "post",
                        data: {
                            id: "${personaInstance?.id}"
                        }
                    }
                }
            },
            messages      : {
                mail : {
                    remote: "Ya existe Mail"
                },
                login: {
                    remote: "Ya existe Login"
                }
            }
        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormPersona();
                return false;
            }
            return true;
        });

        $("#btn-addPerfil").click(function () {
            var $perfil = $("#perfil");
            var idPerfilAdd = $perfil.val();
            $(".perfiles").each(function () {
                if ($(this).data("id") == idPerfilAdd) {
                    $(this).remove();
                }
            });
            var $tabla = $("#tblPerfiles");

            var $tr = $("<tr>");
            $tr.addClass("perfiles");
            $tr.data("id", idPerfilAdd);
            var $tdNombre = $("<td>");
            $tdNombre.text($perfil.find("option:selected").text());
            var $tdBtn = $("<td>");
            $tdBtn.attr("width", "35");
            var $btnDelete = $("<a>");
            $btnDelete.addClass("btn btn-danger btn-xs");
            $btnDelete.html("<i class='fa fa-trash-o'></i> ");
            $tdBtn.append($btnDelete);

            $btnDelete.click(function () {
                $tr.remove();
                return false;
            });

            $tr.append($tdNombre).append($tdBtn);

            $tabla.prepend($tr);
            $tr.effect("highlight");

            return false;
        });
        $(".btn-deletePerfil").click(function () {
            $(this).parents("tr").remove();
            return false;
        });

    </script>

</g:else>