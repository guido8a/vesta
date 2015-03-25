<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 20/03/15
  Time: 01:13 PM
--%>


<%@ page import="vesta.poa.Asignacion" %>
<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>

<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>

<g:hasErrors bean="${asignacionInstance}">
    <div class="errors ui-state-error ui-corner-all">
        <g:renderErrors bean="${asignacionInstance}" as="list"/>
    </div>
</g:hasErrors>

<g:form action="creaHijoMod" class="frmModAsignaciones" method="post" enctype="multipart/form-data">
    <g:hiddenField name="id" value="${asignacionInstance?.id}"/>
    <g:hiddenField name="unidad" value="${unidad?.id}"/>
    <g:hiddenField name="maximo" value="${asignacionInstance?.getValorReal()?.toFloat()?.round(2)}"/>


    <div class="form-group keeptogether">
        <div class="col-md-10">
            <span class="grupo">
                <label class="col-md-4 control-label">
                    Fuente
                </label>

                <div class="col-md-6">
                    <g:select class="field ui-widget-content ui-corner-all" name="fuente"
                              title="Fuente de financiamiento" from="${fuentes}" optionKey="id"
                              value="${asignacionInstance?.fuente?.id}" noSelection="['null': '']"/>
                </div>
            </span>
        </div>
    </div>

    <div class="form-group keeptogether">
        <div class="col-md-10">
            <span class="grupo">
                <label class="col-md-4 control-label">
                    Presupuesto
                </label>

                <div class="col-md-8">
                    <input type="hidden" class="prsp" value="${asignacionInstance?.presupuesto?.id}" id="prsp2" name="presupuesto.id">
                    <input type="text" id="prsp_desc2" desc="desc2" style="width: 100px;border: 1px solid black" class="buscarAgr ui-corner-all required">
                    <span style="font-size: smaller;">Haga clic para consultar</span>
                    <div id="desc2" style="width: 300px;font-size: 10px;text-align: left"></div>
                </div>
            </span>
        </div>
    </div>

    <div class="form-group keeptogether">
        <div class="col-md-10">
            <span class="grupo">
                <label class="col-md-4 control-label">
                    Valor
                </label>

                <div class="col-md-6">
                    <g:textField class="field number required ui-widget-content ui-corner-all money" name="valor"
                                 title="Planificado" id="vlor"
                                 value='${formatNumber(number:asignacionInstance.getValorReal(),format:"###,##0",minFractionDigits:2,maxFractionDigits:2)}'/>
                </div>
            </span>
        </div>
    </div>

    <div class="form-group keeptogether">
        <div class="col-md-10">
            <span class="grupo">
                <label class="col-md-4 control-label">
                    Autorización
                </label>

                <div class="col-md-6">
                    <input type="file" name="archivo">
                </div>
            </span>
        </div>
    </div>


    <script type="text/javascript">


        $(".buscarAgr").click(function() {
            $("#id_txt").val($(this).attr("id"))
            $("#id_desc").val($(this).attr("desc"))
//            $("#buscarAgr").dialog("open")


            $.ajax({
                type: "POST",
                url: "${createLink(action:'buscarPresupuesto_ajax',controller:'asignacion')}",
//                data: "parametro=" + $("#par2").val() + "&tipo=" + $("#tipo").val(),
                data: "parametro=" + "" + "&tipo=" + "1",
                success: function(msg) {
                    bootbox.dialog ({
                        id: "dlgBuscarPre",
                        title: "Buscar Presupuesto",
//                        class: "modal-lg",
                        message: msg,
                        buttons : {
                            cancelar : {
                                label     : "Cancelar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            }
                        }
                    })
                }
            });
        });



        %{--$("#btn_buscarAgr").click(function() {--}%
            %{--$.ajax({--}%
                %{--type: "POST",--}%
                %{--url: "${createLink(action:'buscarPresupuesto',controller:'asignacion')}",--}%
                %{--data: "parametro=" + $("#par2").val() + "&tipo=" + $("#tipo").val(),--}%
                %{--success: function(msg) {--}%
                    %{--$("#resultadoAgr").html(msg)--}%
                %{--}--}%
            %{--});--}%
        %{--});--}%



//        $("#buscarAgr").dialog({
//            title:"Cuentas presupuestarias",
//            width:520,
//            height:480,
//            autoOpen:false,
//            modal:true
//        })
    </script>
</g:form>
