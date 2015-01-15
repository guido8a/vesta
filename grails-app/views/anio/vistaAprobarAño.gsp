<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Aprobar gastos e inversiones</title>
</head>
<body>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
<elm:container tipo="horizontal" titulo="Aprobar P.O.A" color="black" >
    <div class="row">
        <elm:fieldRapido label="Seleccione un año:" claseField="col-md-2">
            <g:select from="${anios}" name="anios" optionKey="id" optionValue="anio" noSelection="[0:'Seleccione']" id="anio" class="form-control input-sm"/>
        </elm:fieldRapido>
    </div>
</elm:container>
<elm:container tipo="vertical" titulo="Detalle"  style="min-height: 250px" >
    <div id="detalle" class="ui-corner-all" >


    </div>
</elm:container>

<script type="text/javascript">
    $("#anio").change(function(){
        if($(this).val()!="0"){
            $.ajax({
                type: "POST",
                url: "${createLink(action:'detalleAnio',controller:'anio')}",
                data: "anio=" + $(this).val(),
                success: function(msg) {
                    $("#detalle").html(msg)
                    $("#detalle").show("slide")
                }
            });
        }
    });
</script>
</body>
</html>