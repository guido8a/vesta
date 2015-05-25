<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 26/01/15
  Time: 12:40 PM
--%>

<%@ page import="vesta.hitos.AvanceAvance" %>
<table class="table table-condensed table-bordered table-striped table-hover">
    <thead>
    <tr>
        <th>Subactividad</th>
        <th>Aporte</th>
        <th>Inicio</th>
        <th>Fin</th>
        <th>Completado</th>
        <th style="width:30px;"><i class="fa fa-pie-chart"></i> </th>
        <th style="width:30px;">Registrar</th>
        <th style="width:60px;"><i class="fa fa-trash"></i> </th>
    </tr>
    </thead>
    <tbody>
    <g:set var="total" value="${0}"/>
    <g:set var="completado" value="${0}"/>
    <g:each in="${avances}" var="avance" status="i">
        <g:set var="total" value="${total + avance.avance}"/>
        <tr data-id="${avance?.id}">
            <td>${avance.observaciones}</td>
            <td style="text-align: right;">
                <g:formatNumber number="${avance.avance}" maxFractionDigits="2" minFractionDigits="2"/>%

            </td>
            <td style="text-align: center">${avance.inicio?.format("dd-MM-yyyy")}</td>
            <td style="text-align: center">${avance.fin?.format("dd-MM-yyyy")}</td>
            <g:set var="valor" value="${avance.getAvanceFisico()}"/>
            <td style="text-align: right"><g:formatNumber number="${valor}" maxFractionDigits="2" minFractionDigits="2"/>%</td>
            <td>
                <g:set var="data" value="${avance.getColorSemaforo()}"/>
                <div class="semaforo ${data[2]}" title="Avance esperado al ${new Date().format('dd/MM/yyyy')}: ${data[0].toDouble().round(2)}%, avance registrado: ${data[1].toDouble().round(2)}%">
                </div>
            </td>
            <td>
                <g:set var="avance123" value="${AvanceAvance.findAllByAvanceFisico(avance, [sort: 'avance', order: "desc"])}"/>
                <a href="#" class="btnCompletar btn btn-success btn-sm" id="${avance.id}"
                   data-min="${avance123 && avance123.size() > 0 ? avance123.first().avance : 0}">
                <i class="fa fa-check-circle"></i> Registrar avance
                </a>
            </td>
            <td style="text-align: center">
                <g:if test="${valor == 0}">
                    <a href="#" class="btnDelete btn-danger btn-sm" id="${avance.id}" title="Borrar"><i class="fa fa-trash"></i> </a>
                </g:if>
            </td>
        </tr>
    </g:each>
    <tr>
        <td style="font-weight: bold;text-align: right">
            Total  planificado:
        </td>
        <td style="font-weight: bold;text-align: right">
            <g:formatNumber number="${total}" minFractionDigits="2" maxFractionDigits="2"/>%
        </td>
        <td colspan="2" style="text-align: right;font-weight: bold">
            Total completado:
        </td>
        <td style="font-weight: bold;text-align: right">
            <g:formatNumber number="${proceso.getAvanceFisico()}" minFractionDigits="2" maxFractionDigits="2"/>%
        </td>
    </tr>
    </tbody>
</table>


<script type="text/javascript">
    var min;
    $(".btnDelete").button({
        text  : false,
        icons : {
            primary : "ui-icon-trash"
        }
    }).click(function () {
        var id = $(this).attr("id");
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'deleteAvanceFisicoProceso_ajax')}",
            data    : {
                id : id
            },
            success : function (msg) {
                updateAll(msg);
            }
        });
        return false;
    });

    %{--$("#dlgAvance").dialog({--}%
        %{--autoOpen : false,--}%
        %{--modal    : true,--}%
        %{--width    : 550,--}%
        %{--title    : "Registrar avance",--}%
        %{--close    : function (event, ui) {--}%
            %{--$("#avanceAvance").val("");--}%
        %{--},--}%
        %{--buttons  : {--}%
            %{--"Guardar"  : function () {--}%
                %{--var avance = $.trim($("#avanceAvance").val());--}%
                %{--var descripcion = $.trim($("#descripcionAvance").val());--}%
                %{--if (avance == "" || isNaN(avance) || avance * 1 <= min || avance * 1 > 100) {--}%
                    %{--$.box({--}%
                        %{--imageClass : "box_info",--}%
                        %{--text       : "El avance debe ser un número positivo mayor a " + min + " y menor a 100",--}%
                        %{--title      : "Error",--}%
                        %{--iconClose  : false,--}%
                        %{--dialog     : {--}%
                            %{--resizable     : false,--}%
                            %{--draggable     : false,--}%
                            %{--closeOnEscape : false,--}%
                            %{--buttons       : {--}%
                                %{--"Aceptar" : function () {--}%
                                %{--}--}%
                            %{--}--}%
                        %{--}--}%
                    %{--});--}%
                %{--} else {--}%
                    %{--if (descripcion == "") {--}%
                        %{--$.box({--}%
                            %{--imageClass : "box_info",--}%
                            %{--text       : "La descripción es obligatoria",--}%
                            %{--title      : "Error",--}%
                            %{--iconClose  : false,--}%
                            %{--dialog     : {--}%
                                %{--resizable     : false,--}%
                                %{--draggable     : false,--}%
                                %{--closeOnEscape : false,--}%
                                %{--buttons       : {--}%
                                    %{--"Aceptar" : function () {--}%
                                    %{--}--}%
                                %{--}--}%
                            %{--}--}%
                        %{--});--}%
                    %{--} else {--}%
                        %{--$.ajax({--}%
                            %{--type    : "POST",--}%
                            %{--url     : "${createLink(action:'agregarAvance')}",--}%
                            %{--data    : {--}%
                                %{--id     : $("#idAvance").val(),--}%
                                %{--avance : avance,--}%
                                %{--desc   : descripcion--}%
                            %{--},--}%
                            %{--success : function (msg) {--}%
                                %{--location.reload(true)--}%

                            %{--}--}%
                        %{--});--}%
                    %{--}--}%
                %{--}--}%
                %{--$("#dlgNuevo").dialog("close");--}%
            %{--},--}%
            %{--"Cancelar" : function () {--}%
                %{--$("#dlgAvance").dialog("close");--}%
            %{--}--}%
        %{--}--}%
    %{--});--}%


    $(".btnCompletar").click(function () {
        var idAv2 = $(this).attr("id");
       registrarAv(idAv2);
    });

    function registrarAv (id) {
        var idAv1 = id;
        $.ajax({
           type : "POST",
            url : "${createLink(action: 'detalleAv')}",
            data : {id: idAv1}
            ,
            success : function (msg) {
                var b = bootbox.dialog ({
                    id : "dlgRegAv",
                    title : "Registrar Avance",
                    class : "modal-lg",
                    message : msg,
                    buttons : {
                        guardar: {
                        id: "btnSave",
                        label : "<i class='fa fa-save'></i> Guardar",
                        classname: "btn-success",
                        callback : function () {
                            var avance = $.trim($("#avanceAvance").val());
                            var descripcion = $.trim($("#descripcionAvance").val());
                            if (avance == "" || isNaN(avance) || avance * 1 <= min || avance * 1 > 100) {
                                log("El avance debe ser un número positivo mayor a " + min + " y menor a 100", 'error')
                                return false
                            } else {
                                if (descripcion == "") {
                                    log("La descripción es obligatoria", 'error')
                                    return false
                                } else {
                                    $.ajax({
                                        type    : "POST",
                                        url     : "${createLink(action:'agregarAvance')}",
                                        data    : {
                                            id     : idAv1,
                                            avance : avance,
                                            desc   : descripcion
                                        },
                                        success : function (msg) {
                                            location.reload(true)

                                        }
                                    });
                                }
                            }

                        }
                    },
                        cancelar: {
                            label : "Cancelar",
                            classname: "btn-primary",
                            callback : function () {
                            }
                        }
                    }
                });
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            }
        });
    }

</script>