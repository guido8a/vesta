<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 22/12/15
  Time: 10:48 AM
--%>
<form id="fechas">

    <div class="row">
        <div class="col-md-1">
            <label>Fecha Incio</label>
        </div>

        <div class="col-md-4 grupo">
            <elm:datepicker class="form-control input-sm fechaInicio required"
                            name="fechaInicio"
                            title="Fecha inicio"
                            id="inicio"/>

        </div>

        <div class="col-md-1">
            <label>Fecha Fin</label>
        </div>

        <div class="col-md-4 grupo">
            <elm:datepicker class="form-control input-sm fechaFin required"
                            name="fechaFin"
                            title="Fecha fin"
                            id="fin"
                            format="dd-MM-yyyy"/>
        </div>
    </div>

</form>



<script type="text/javascript">


    $("#fechas").validate({
        errorClass     : "help-block",
        onfocusout     : false,
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