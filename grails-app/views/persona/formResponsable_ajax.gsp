<%@ page import="vesta.parametros.TipoResponsable" %>

<g:form class="form-horizontal" name="frmResponsable" role="form" action="addResponsable_ajax" method="POST">
    <div class="form-group keeptogether required">
        <div class="col-md-6">
            <span class="grupo">
                <label for="tipo" class="col-md-4 control-label">
                    Tipo
                </label>

                <div class="col-md-8">
                    <g:select class="form-control input-sm required" name="tipo"
                              from="${TipoResponsable.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion"/>
                </div>
            </span>
        </div>

        <div class="col-md-6">
            <span class="grupo">
                <label for="responsable" class="col-md-4 control-label">
                    Responsable
                </label>

                <div class="col-md-8" id="divResponsable">
                    <g:select class="form-control input-sm required" name="responsable"
                              from="" optionKey="id" noSelection="['': '']" optionValue="persona"/>
                </div>
            </span>
        </div>
    </div>

    <div class="form-group keeptogether required">
        <div class="col-md-6">
            <span class="grupo">
                <label for="desde" class="col-md-4 control-label">
                    Desde
                </label>

                <div class="col-md-8">
                    <elm:datepicker name="desde" class="datepicker form-control input-sm"
                                    onChangeDate="validaFechas"/>
                </div>
            </span>
        </div>

        <div class="col-md-6">
            <span class="grupo">
                <label for="hasta" class="col-md-4 control-label">
                    Hasta
                </label>

                <div class="col-md-8">
                    <elm:datepicker name="hasta" class="datepicker form-control input-sm"
                                    onChangeDate="validaFechas2"/>
                </div>
            </span>
        </div>
    </div>

    <div class="form-group keeptogether required">
        <div class="col-md-12">
            <span class="grupo">
                <label for="observaciones" class="col-md-2 control-label">
                    Observaciones
                </label>

                <div class="col-md-10">
                    <g:textArea name="observaciones" class="form-control input-sm"/>
                </div>
            </span>
        </div>
    </div>
</g:form>

<script type="text/javascript">
    function validaFechas($elm, e) {
        $("#hasta_input").data("DateTimePicker").setMinDate(e.date);
    }
    function validaFechas2($elm, e) {
        $('#desde_input').data("DateTimePicker").setMaxDate(e.date);
    }

    function reloadResponsables() {
        var tipo = $("#tipo").val();
        var unidad = "${unidad.id}";
        var $divResp = $("#divResponsable");

        var url = "${resource(dir:'images/spinners', file:'spinner_24.GIF')}";
        $divResp.html("<img src='" + url + "' />");

        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'responsablesPorTipo_ajax')}",
            data    : {
                tipo   : tipo,
                unidad : unidad
            },
            success : function (msg) {
                $divResp.html(msg);
            }
        });
    }
    $(function () {
        reloadResponsables();
        $("#tipo").change(function () {
            reloadResponsables();
        });

        var validator = $("#frmResponsable").validate({
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
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitFormResponsable();
                return false;
            }
            return true;
        });
    });
</script>