<input type="hidden" value="${anio.id}" id="anio">
<table class="table table-condensed table-bordered table-striped">
    <thead>
    <tr>
        <th></th>
        <th colspan="3" >Proyectos</th>
    </tr>
    <tr>
        <th >Unidad ejecutora</th>
        <th >Asignaciones</th>
        <th>Total</th>
    </tr>
    </thead>
    <tbody>
    <g:set var="totCantProy" value="0"></g:set>
    <g:set var="totProy" value="0"></g:set>
    <g:set var="totCantCor" value="0"></g:set>
    <g:set var="totCor" value="0"></g:set>
    <g:set var="totCantObraProy" value="0"></g:set>
    <g:set var="totObraProy" value="0"></g:set>
    <g:set var="totCantObraCor" value="0"></g:set>
    <g:set var="totObraCor" value="0"></g:set>
    <g:each in="${datos}" var="dato" status="i">
        <g:set var="totCantProy" value="${totCantProy.toInteger()+dato.value.get(1)}"></g:set>
        <g:set var="totProy" value="${totProy.toDouble()+dato.value.get(0)}"></g:set>
        <g:set var="totCantCor" value="${totCantCor.toInteger()+dato.value.get(5)}"></g:set>
        <g:set var="totCor" value="${totCor.toDouble()+dato.value.get(4)}"></g:set>
        <g:set var="totCantObraProy" value="${totCantObraProy.toInteger()+dato.value.get(3)}"></g:set>
        <g:set var="totObraProy" value="${totObraProy.toDouble()+dato.value.get(2)}"></g:set>
        <g:set var="totCantObraCor" value="${totCantObraCor.toInteger()+dato.value.get(7)}"></g:set>
        <g:set var="totObraCor" value="${totObraCor.toDouble()+dato.value.get(6)}"></g:set>
        <tr >
            <td >${dato.key}</td>
            %{--<td style="background: #FFAB48;text-align: right;border: 1px solid #000000">${dato.value.get(1)}</td>--}%
            <td style="text-align: right" >${dato.value.get(1)}</td>
            <td style="text-align: right"> <g:formatNumber number="${dato.value.get(0)}" type="currency" currencySymbol="" /></td>

        </tr>
    </g:each>
    <tr>
        <td ><b>Total</b></td>
        <td style="text-align: right;font-weight: bold" >${totCantProy}</td>
        <td style="text-align: right;font-weight: bold"><g:formatNumber number="${totProy.toDouble()}" type="currency" currencySymbol=""/></td></td>


    </tr>
    </tbody>

</table>

<g:if test="${anio.estado==0}">
    <a href="#" style="margin-top: 10px;margin-bottom: 10px" class="btn btn-primary" id="aprobar">Aprobar proforma</a>
</g:if>
<g:else>
    Las asignaciones ya han sido aprobadas para este año
</g:else>
<script type="text/javascript">


    $("#aprobar").click(function(){
        var boton = $(this)
        bootbox.confirm({
                    message: "Esta seguro?",
                    title :"Advertencia",
                    class : "modal-error",
                    callback : function (result){
                        if(result){
                            openLoader()
                            $.ajax({
                                type: "POST",
                                url: "${createLink(action:'aprobarAnio')}",
                                data: {
                                    anio:$("#anio").val()
                                },
                                success: function(msg) {
                                    if(msg!="no"){
                                        window.location.href="${createLink(action:'vistaAprobarAño')}"
                                    }else{
                                        log("Error interno")
                                    }
                                }
                            });
                        }

                    }
                }
        );


    });
</script>