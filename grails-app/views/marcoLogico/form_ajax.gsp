<%@ page import="vesta.proyectos.MarcoLogico" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!marcoLogicoInstance}">
    <elm:notFound elem="MarcoLogico" genero="o"/>
</g:if>
<g:else>

    <div class="modal-contenido">
        <g:form class="form-horizontal" name="frmMarcoLogico" role="form" action="save_ajax" method="POST">
            <g:hiddenField name="id" value="${marcoLogicoInstance?.id}"/>


            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'proyecto', 'error')} ">
                <span class="grupo">
                    <label for="proyecto" class="col-md-2 control-label">
                        Proyecto
                    </label>

                    <div class="col-md-7">
                        <g:select id="proyecto" name="proyecto.id" from="${vesta.proyectos.Proyecto.list()}" optionKey="id" value="${marcoLogicoInstance?.proyecto?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'tipoElemento', 'error')} ">
                <span class="grupo">
                    <label for="tipoElemento" class="col-md-2 control-label">
                        Tipo Elemento
                    </label>

                    <div class="col-md-7">
                        <g:select id="tipoElemento" name="tipoElemento.id" from="${vesta.parametros.TipoElemento.list()}" optionKey="id" value="${marcoLogicoInstance?.tipoElemento?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'marcoLogico', 'error')} ">
                <span class="grupo">
                    <label for="marcoLogico" class="col-md-2 control-label">
                        Marco Logico
                    </label>

                    <div class="col-md-7">
                        <g:select id="marcoLogico" name="marcoLogico.id" from="${vesta.proyectos.MarcoLogico.list()}" optionKey="id" value="${marcoLogicoInstance?.marcoLogico?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'modificacionProyecto', 'error')} ">
                <span class="grupo">
                    <label for="modificacionProyecto" class="col-md-2 control-label">
                        Modificacion Proyecto
                    </label>

                    <div class="col-md-7">
                        <g:select id="modificacionProyecto" name="modificacionProyecto.id" from="${vesta.proyectos.ModificacionProyecto.list()}" optionKey="id" value="${marcoLogicoInstance?.modificacionProyecto?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'objeto', 'error')} ">
                <span class="grupo">
                    <label for="objeto" class="col-md-2 control-label">
                        Objeto
                    </label>

                    <div class="col-md-7">
                        <g:textArea name="objeto" cols="40" rows="5" maxlength="1023" class="form-control input-sm" value="${marcoLogicoInstance?.objeto}"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'monto', 'error')} required">
                <span class="grupo">
                    <label for="monto" class="col-md-2 control-label">
                        Monto
                    </label>

                    <div class="col-md-3">
                        <g:field name="monto" type="number" value="${fieldValue(bean: marcoLogicoInstance, field: 'monto')}" class="number form-control input-sm  required" required=""/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'estado', 'error')} required">
                <span class="grupo">
                    <label for="estado" class="col-md-2 control-label">
                        Estado
                    </label>

                    <div class="col-md-3">
                        <g:field name="estado" type="number" value="${marcoLogicoInstance.estado}" class="digits form-control input-sm required" required=""/>
                    </div>
                    *
                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'padreMod', 'error')} ">
                <span class="grupo">
                    <label for="padreMod" class="col-md-2 control-label">
                        Padre Mod
                    </label>

                    <div class="col-md-7">
                        <g:select id="padreMod" name="padreMod.id" from="${vesta.proyectos.MarcoLogico.list()}" optionKey="id" value="${marcoLogicoInstance?.padreMod?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'categoria', 'error')} ">
                <span class="grupo">
                    <label for="categoria" class="col-md-2 control-label">
                        Categoria
                    </label>

                    <div class="col-md-7">
                        <g:select id="categoria" name="categoria.id" from="${vesta.proyectos.Categoria.list()}" optionKey="id" value="${marcoLogicoInstance?.categoria?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'responsable', 'error')} ">
                <span class="grupo">
                    <label for="responsable" class="col-md-2 control-label">
                        Responsable
                    </label>

                    <div class="col-md-7">
                        <g:select id="responsable" name="responsable.id" from="${vesta.parametros.UnidadEjecutora.list()}" optionKey="id" value="${marcoLogicoInstance?.responsable?.id}" class="many-to-one form-control input-sm" noSelection="['null': '']"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'fechaFin', 'error')} ">
                <span class="grupo">
                    <label for="fechaFin" class="col-md-2 control-label">
                        Fecha Fin
                    </label>

                    <div class="col-md-5">
                        <elm:datepicker name="fechaFin" class="datepicker form-control input-sm" value="${marcoLogicoInstance?.fechaFin}" default="none" noSelection="['': '']"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'fechaInicio', 'error')} ">
                <span class="grupo">
                    <label for="fechaInicio" class="col-md-2 control-label">
                        Fecha Inicio
                    </label>

                    <div class="col-md-5">
                        <elm:datepicker name="fechaInicio" class="datepicker form-control input-sm" value="${marcoLogicoInstance?.fechaInicio}" default="none" noSelection="['': '']"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'tieneAsignacion', 'error')} ">
                <span class="grupo">
                    <label for="tieneAsignacion" class="col-md-2 control-label">
                        Tiene Asignacion
                    </label>

                    <div class="col-md-7">
                        <g:textField name="tieneAsignacion" class="form-control input-sm" value="${marcoLogicoInstance?.tieneAsignacion}"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'numeroComp', 'error')} ">
                <span class="grupo">
                    <label for="numeroComp" class="col-md-2 control-label">
                        Numero Comp
                    </label>

                    <div class="col-md-7">
                        <g:textField name="numeroComp" class="form-control input-sm" value="${marcoLogicoInstance?.numeroComp}"/>
                    </div>

                </span>
            </div>

            <div class="form-group keeptogether ${hasErrors(bean: marcoLogicoInstance, field: 'numero', 'error')} required">
                <span class="grupo">
                    <label for="numero" class="col-md-2 control-label">
                        Numero
                    </label>

                    <div class="col-md-3">
                        <g:field name="numero" type="number" value="${marcoLogicoInstance.numero}" class="digits form-control input-sm required" required=""/>
                    </div>
                    *
                </span>
            </div>

        </g:form>
    </div>

    <script type="text/javascript">
        var validator = $("#frmMarcoLogico").validate({
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
                submitFormMarcoLogico();
                return false;
            }
            return true;
        });
    </script>

</g:else>