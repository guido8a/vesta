<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 02/03/16
  Time: 11:06 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>


<g:form action="guardarCambioNumero" name="frmNumero" method="POST" role="form">
    <input type="hidden" name="id" id="id" value="${aval.id}">

    <div style="padding: 5px;" class="">
        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-3 control-label">
                    Número de Solicitud:
                </label>
                <label for="numActual" class="col-md-1 control-label">
                    Actual
                </label>
                <div class="col-md-2">
                    <g:textField class="form-control input-sm" name="numActual" id="numActual" value="${solicitud?.numero}" disabled="disabled"/>
                </div>
                <label for="numNuevo" class="col-md-1 control-label">
                    Nuevo
                </label>
                <div class="col-md-2">
                    <g:textField class="form-control input-sm required number" name="numNuevo" id="numNuevo" value="${solicitud?.numero}" maxlength="10"/>
                </div>
            </span>
        </div>
        <div class="form-group keeptogether">
            <span class="grupo">
                <label class="col-md-3 control-label">
                    Número de Aval:
                </label>
                <label for="numActualAval" class="col-md-1 control-label">
                    Actual
                </label>
                <div class="col-md-2">
                    <g:textField class="form-control input-sm" name="numActualAval" id="numActualAval" value="${aval?.numero}" disabled="disabled"/>
                </div>
                <label for="numNuevoAval" class="col-md-1 control-label">
                    Nuevo
                </label>
                <div class="col-md-2">
                    <g:textField class="form-control input-sm required number" name="numNuevoAval" id="numNuevoAval" value="${aval?.numero}" maxlength="10"/>
                </div>
            </span>
        </div>
    </div>
</g:form>

<script type="text/javascript">


    var validator = $("#frmNumero").validate({
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

    function validarNum(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
        (ev.keyCode >= 96 && ev.keyCode <= 105) ||
        ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
        ev.keyCode == 37 || ev.keyCode == 39);
    }

    $(".form-control").keydown(function (ev) {
        if (ev.keyCode == 190 || ev.keyCode == 110 || ev.keyCode == 188 ) {

            return false;
        }
        return true;
    });



</script>