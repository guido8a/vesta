<g:select from="${comps}" optionValue="objeto" optionKey="id" name="comp" id="comp" noSelection="['-1': 'Seleccione...']" class="form-control input-sm required"></g:select>
%{--<script>--}%
    %{--$("#comp").change(function () {--}%
        %{--$.ajax({--}%
            %{--type    : "POST",--}%
            %{--url     : "${createLink(action:'cargarActividades',controller: 'hito')}",--}%
            %{--data    : {--}%
                %{--id : $("#comp").val()--}%
            %{--},--}%
            %{--success : function (msg) {--}%
                %{--$("#divAct").html(msg)--}%
            %{--}--}%
        %{--});--}%


    %{--})--}%

%{--</script>--}%