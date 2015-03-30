<g:select from="${acts}" optionValue="objeto" optionKey="id" name="act" id="actividad" noSelection="['-1': 'Seleccione...']" style="width: 100%"></g:select>
<script>
    $("#actividad").selectmenu({width : 600});
</script>