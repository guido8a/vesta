<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 02/10/15
  Time: 12:20 PM
--%>

<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 02/10/15
  Time: 09:48 AM
--%>
<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 14/01/15
  Time: 03:24 PM
--%>

<%@ page import="vesta.parametros.TipoElemento" contentType="text/html;charset=UTF-8" %>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<g:form action="guardarCambioFechas" name="frmFechas" method="POST" role="form">
    <input type="hidden" name="id" id="id" value="${aval.id}">

    <div style="padding: 5px;" class="alert alert-info">
        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="inicio" class="col-md-5 control-label">
                   Fecha Inicio:
                </label>
                <div class="col-md-5">
                    <elm:datepicker id="inicio" name="fechaInicio" class="datepicker form-control input-sm" value="${aval?.fechaInicioProceso}"/>
                </div>
            </span>
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="fin" class="col-md-5 control-label">
                    Fecha Fin:
                </label>
                    <div class="col-md-5">
                        <elm:datepicker id="fin" name="fechaFin" class="form-control input-sm" value="${aval?.fechaFinProceso}"/>
                    </div>
            </span>
        </div>
    </div>

    <div style="padding: 5px;" class="alert alert-success">
        <div class="form-group keeptogether">
            <span class="grupo">
                <label for="codigo" class="col-md-5 control-label">
                    Clave de autorización:
                </label>
                    <div class="col-md-5">
                        <span class="input-group-addon"><g:textField class="form-control input-sm required number" name="codigo" /><i class="fa fa-lock"></i> </span>
                    </div>
            </span>
            *
        </div>
    </div>

</g:form>

<script type="text/javascript">

    var validator = $("#frmLiberar").validate({
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
            label.remove();
        }
    });

</script>
